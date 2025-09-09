terraform {
  required_version = ">= 1.9.7, < 1.10.0"
}

# Local values
locals {
  # Get unique AZs from private for route table creation
  private_azs = toset(concat(
    [for subnet in var.private_subnets : subnet.az]
  ))
  
  # Create a map of NAT gateways by AZ for routing
  nat_gateway_by_az = var.create_nat_gateway && length(var.public_subnets) > 0 ? {
    for i, subnet in var.public_subnets : subnet.az => aws_nat_gateway.main[i].id
  } : {}


  tgw_subnet_ids = [
    for s in aws_subnet.private : s.id
    if s.tags["Purpose"] == "tgw"
  ]

  private_route_tables = {
    for az, rt in aws_route_table.private : az => rt.id
  }
  # Get unique AZs from private subnets
  unique_azs = toset([for subnet in var.private_subnets : subnet.az])
  
  # Create a map that combines each unique AZ with each TGW route
  tgw_route_combinations = var.attach_to_tgw ? {
    for combo in setproduct(tolist(local.unique_azs), keys(var.tgw_routes)) :
    "${combo[0]}-${combo[1]}" => {
      az         = combo[0]
      route_name = combo[1]
      cidr       = var.tgw_routes[combo[1]]
    }
  } : {}
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  
  tags = merge(var.common_tags, {
    Name = var.vpc_name
  })
}

# Private Subnets
resource "aws_subnet" "private" {
  count = length(var.private_subnets)

  vpc_id            = aws_vpc.main.id
  availability_zone = var.private_subnets[count.index].az
  cidr_block        = var.private_subnets[count.index].cidr

  tags = merge(var.common_tags, {
    Type    = "Private"
    Purpose = var.private_subnets[count.index].purpose
    Name    = "${var.vpc_name}-private-${var.private_subnets[count.index].purpose}-${var.private_subnets[count.index].az}"
  })
}


# Public Subnets
resource "aws_subnet" "public" {
  count = length(var.public_subnets) > 0 ? length(var.public_subnets) : 0
  
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.main.id
  availability_zone       = var.public_subnets[count.index].az
  cidr_block              = var.public_subnets[count.index].cidr
  
  tags = merge(var.common_tags, {
    Type = "Public"
    Name = "${var.vpc_name}-public-${var.public_subnets[count.index].az}"
  })
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  count = var.create_igw && length(var.public_subnets) > 0 ? 1 : 0
  
  vpc_id = aws_vpc.main.id
  
  tags = merge(var.common_tags, {
    Name = "${var.vpc_name}-igw"
  })
}

# Route Table for Public Subnets
resource "aws_route_table" "public" {
  count = length(var.public_subnets) > 0 ? 1 : 0
  
  vpc_id = aws_vpc.main.id
  
  dynamic "route" {
    for_each = var.create_igw ? [1] : []
    content {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.main[0].id
    }
  }
  
  tags = merge(var.common_tags, {
    Name = "${var.vpc_name}-public-rt"
    Type = "Public"
  })
}

# Route Tables for Private Subnets (one per AZ)
resource "aws_route_table" "private" {
  for_each = local.private_azs
  
  vpc_id = aws_vpc.main.id
  
  # Add NAT Gateway route if NAT exists for this AZ
  dynamic "route" {
    for_each = lookup(local.nat_gateway_by_az, each.key, null) != null ?  [1] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = local.nat_gateway_by_az[each.key]
    }
  }
  
  tags = merge(var.common_tags, {
    Name = "${var.vpc_name}-private-${each.key}-rt"
    Type = "Private"
  })
}

# Route Table Associations for Public Subnets
resource "aws_route_table_association" "public" {
  count = length(var.public_subnets) > 0 ? length(var.public_subnets) : 0
  
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[0].id
}

# Route Table Associations for Private Subnets
resource "aws_route_table_association" "private" {
  count = length(var.private_subnets)
  
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[var.private_subnets[count.index].az].id
}

# NAT Gateway EIPs
resource "aws_eip" "nat" {
  count = var.create_nat_gateway && length(var.public_subnets) > 0 ? length(var.public_subnets) : 0
  
  domain = "vpc"
  
  tags = merge(var.common_tags, {
    Name = "${var.vpc_name}-nat-eip-${count.index + 1}"
  })
  
  depends_on = [aws_internet_gateway.main]
}

# NAT Gateways
resource "aws_nat_gateway" "main" {
  count = var.create_nat_gateway && length(var.public_subnets) > 0 ? length(var.public_subnets) : 0
  
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
  
  tags = merge(var.common_tags, {
    Name = "${var.vpc_name}-nat-${var.public_subnets[count.index].az}"
  })
  
  depends_on = [aws_internet_gateway.main]
}

# Transit Gateway Attachment
resource "aws_ec2_transit_gateway_vpc_attachment" "main" {
  count = var.attach_to_tgw ? 1 : 0
  
  vpc_id             = aws_vpc.main.id
  subnet_ids         = local.tgw_subnet_ids
  transit_gateway_id = var.transit_gateway_id
  
  tags = merge(var.common_tags, {
    Name = "${var.vpc_name}-tgw-attachment"
  })
}

resource "time_sleep" "wait_for_tgw_attachment" {
  depends_on = [aws_ec2_transit_gateway_vpc_attachment.main]

  # wait a bit for AWS to switch to 'pendingAcceptance'
  create_duration = "30s"
}

resource "aws_ec2_transit_gateway_vpc_attachment_accepter" "this" {
  provider  = aws.networking_account
  count     = var.attach_to_tgw ? 1 : 0

  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  transit_gateway_attachment_id                   = aws_ec2_transit_gateway_vpc_attachment.main[count.index].id

  tags = merge(var.common_tags, {
    Name = "${var.vpc_name}-tgw-attachment-accepter"
  })

  depends_on = [ aws_ec2_transit_gateway_vpc_attachment.main ]
}

resource "aws_route" "to_tgw" {
  for_each = local.tgw_route_combinations
  
  destination_cidr_block = each.value.cidr
  transit_gateway_id     = var.transit_gateway_id
  route_table_id         = aws_route_table.private[each.value.az].id

  depends_on = [ aws_ec2_transit_gateway_vpc_attachment.main ]
}

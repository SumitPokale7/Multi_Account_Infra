# VPC Outputs
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_arn" {
  description = "ARN of the VPC"
  value       = aws_vpc.main.arn
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "vpc_name" {
  description = "Name of the VPC"
  value       = var.vpc_name
}

# Subnet Outputs
output "private_subnet_ids" {
  description = "Map of private subnets by purpose"
  value = {
    db       = [for s in aws_subnet.private : s.id if s.tags["Purpose"] == "db"]
    app      = [for s in aws_subnet.private : s.id if s.tags["Purpose"] == "app"]
    tgw      = [for s in aws_subnet.private : s.id if s.tags["Purpose"] == "tgw"]
    nat      = [for s in aws_subnet.private : s.id if s.tags["Purpose"] == "nat"]
    gwlb     = [for s in aws_subnet.private : s.id if s.tags["Purpose"] == "gwlb"]
    gwlbe    = [for s in aws_subnet.private : s.id if s.tags["Purpose"] == "gwlbe"]
    firewall = [for s in aws_subnet.private : s.id if s.tags["Purpose"] == "firewall"]
    ssm_vpc_endpoint = [for s in aws_subnet.private : s.id if s.tags["Purpose"] == "ssm_vpc_endpoint"]
  }
}

output "private_subnet_cidrs" {
  description = "List of private subnet CIDR blocks"
  value       = aws_subnet.private[*].cidr_block
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public[*].id
}

output "public_subnet_cidrs" {
  description = "List of public subnet CIDR blocks"
  value       = aws_subnet.public[*].cidr_block
}

# Subnets grouped by AZ
output "private_subnets_by_az" {
  description = "Map of private subnets by availability zone"
  value = {
    for subnet in aws_subnet.private : subnet.availability_zone => subnet.id...
  }
}

output "public_subnets_by_az" {
  description = "Map of public subnets by availability zone"
  value = {
    for subnet in aws_subnet.public : subnet.availability_zone => subnet.id...
  }
}

# Gateway Outputs
output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = var.create_igw ? aws_internet_gateway.main[0].id : null
}

output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs"
  value       = aws_nat_gateway.main[*].id
}

output "nat_gateway_public_ips" {
  description = "List of public IPs for NAT Gateways"
  value       = aws_nat_gateway.main[*].public_ip
}

output "nat_eip_ids" {
  description = "List of Elastic IP allocation IDs for NAT Gateways"
  value       = aws_eip.nat[*].id
}

# Route Table Outputs
output "public_route_table_id" {
  description = "ID of the public route table"
  value       = length(var.public_subnets) > 0 ? aws_route_table.public[0].id : null
}

output "private_route_table_ids" {
  description = "Map of private route table IDs by AZ"
  value       = { for k, v in aws_route_table.private : k => v.id }
}

# Transit Gateway Outputs
output "tgw_attachment_id" {
  description = "ID of the Transit Gateway attachment"
  value       = var.attach_to_tgw ? aws_ec2_transit_gateway_vpc_attachment.main[0].id : null
}

# Summary Output
output "vpc_summary" {
  description = "Summary of VPC and its resources"
  value = {
    vpc_id   = aws_vpc.main.id
    vpc_name = var.vpc_name
    vpc_cidr = aws_vpc.main.cidr_block
    
    subnet_counts = {
      private  = length(aws_subnet.private)
      public   = length(aws_subnet.public)
    }
    
    gateways = {
      internet_gateway = var.create_igw
      nat_gateways     = length(aws_nat_gateway.main)
      tgw_attachment   = var.attach_to_tgw
    }
    
    availability_zones = distinct(concat(
      [for s in var.private_subnets : s.az],
      [for s in var.public_subnets : s.az]
    ))
  }
}

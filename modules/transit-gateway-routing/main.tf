# Security Route Table
resource "aws_ec2_transit_gateway_route_table" "security" {
  count = var.create_security_route_table ? 1 : 0
  
  transit_gateway_id = var.transit_gateway_id
  
  tags = merge(var.common_tags, {
    Name        = "${var.route_table_name_prefix}-security-rt"
    Environment = "security"
    Purpose     = "Security inspection and DMZ routing"
  })
}

# Production Route Table
resource "aws_ec2_transit_gateway_route_table" "production" {
  count = var.create_production_route_table ? 1 : 0
  
  transit_gateway_id = var.transit_gateway_id
  
  tags = merge(var.common_tags, {
    Name        = "${var.route_table_name_prefix}-production-rt"
    Environment = "production"
    Purpose     = "Production workload routing"
  })
}

# Development Route Table
resource "aws_ec2_transit_gateway_route_table" "development" {
  count = var.create_development_route_table ? 1 : 0
  
  transit_gateway_id = var.transit_gateway_id
  
  tags = merge(var.common_tags, {
    Name        = "${var.route_table_name_prefix}-development-rt"
    Environment = "development"
    Purpose     = "Development and testing workload routing"
  })
}

# Routes for Security Route Table
# Allow all traffic in security route table (for inspection)
resource "aws_ec2_transit_gateway_route" "security_default" {
  count = var.create_security_route_table ? 1 : 0
  
  destination_cidr_block         = var.internet_cidr
  transit_gateway_attachment_id  = null # Will be set when attachments are created
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.security[0].id
  
  # This route will need to point to the internet gateway attachment
  # You'll need to update this when creating attachments
}

# Production Route Table Routes
# Route internet traffic through security if enabled
resource "aws_ec2_transit_gateway_route" "production_internet_via_security" {
  count = var.create_production_route_table && var.route_internet_through_security && var.create_security_route_table ? 1 : 0
  
  destination_cidr_block         = var.internet_cidr
  transit_gateway_attachment_id  = null # Will point to security VPC attachment
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.production[0].id
}

# Route to security CIDRs from production
resource "aws_ec2_transit_gateway_route" "production_to_security" {
  count = var.create_production_route_table && var.create_security_route_table ? length(var.security_cidrs) : 0
  
  destination_cidr_block         = var.security_cidrs[count.index]
  transit_gateway_attachment_id  = null # Will point to security VPC attachment
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.production[0].id
}

# Allow production-to-production communication
resource "aws_ec2_transit_gateway_route" "production_internal" {
  count = var.create_production_route_table ? length(var.production_cidrs) : 0
  
  destination_cidr_block         = var.production_cidrs[count.index]
  transit_gateway_attachment_id  = null # Will point to respective production VPC attachments
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.production[0].id
}

# Development Route Table Routes
# Route internet traffic through security if enabled
resource "aws_ec2_transit_gateway_route" "development_internet_via_security" {
  count = var.create_development_route_table && var.route_internet_through_security && var.create_security_route_table ? 1 : 0
  
  destination_cidr_block         = var.internet_cidr
  transit_gateway_attachment_id  = null # Will point to security VPC attachment
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.development[0].id
}

# Route to security CIDRs from development
resource "aws_ec2_transit_gateway_route" "development_to_security" {
  count = var.create_development_route_table && var.create_security_route_table ? length(var.security_cidrs) : 0
  
  destination_cidr_block         = var.security_cidrs[count.index]
  transit_gateway_attachment_id  = null # Will point to security VPC attachment
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.development[0].id
}

# Allow development-to-development communication
resource "aws_ec2_transit_gateway_route" "development_internal" {
  count = var.create_development_route_table ? length(var.development_cidrs) : 0
  
  destination_cidr_block         = var.development_cidrs[count.index]
  transit_gateway_attachment_id  = null # Will point to respective development VPC attachments
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.development[0].id
}

# Conditional routes for environment isolation
# If isolate_environments is false, allow prod-dev communication through security
resource "aws_ec2_transit_gateway_route" "production_to_development_via_security" {
  count = (var.create_production_route_table && 
           var.create_development_route_table && 
           !var.isolate_environments && 
           var.route_development_through_security) ? length(var.development_cidrs) : 0
  
  destination_cidr_block         = var.development_cidrs[count.index]
  transit_gateway_attachment_id  = null # Will point to security VPC attachment for inspection
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.production[0].id
}

resource "aws_ec2_transit_gateway_route" "development_to_production_via_security" {
  count = (var.create_development_route_table && 
           var.create_production_route_table && 
           !var.isolate_environments && 
           var.route_production_through_security) ? length(var.production_cidrs) : 0
  
  destination_cidr_block         = var.production_cidrs[count.index]
  transit_gateway_attachment_id  = null # Will point to security VPC attachment for inspection
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.development[0].id
}

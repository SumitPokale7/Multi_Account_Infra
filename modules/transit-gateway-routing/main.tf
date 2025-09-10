terraform {
  required_version = ">= 1.9.7, < 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.12.0"
    }
  }
}

resource "aws_ec2_transit_gateway_route_table" "this" {
  transit_gateway_id = var.tgw_id
  for_each           = var.route_tables

  tags = {
    Name = each.value.name
  }
}

resource "aws_ec2_transit_gateway_route_table_association" "assoc" {
  for_each = {
    for rt_name, rt in var.route_tables :
    rt_name => rt.associations
  }

  transit_gateway_attachment_id  = each.value[0] # only 1:1 association
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.this[each.key].id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "prop" {
  for_each = {
    for rt_name, rt in var.route_tables :
    rt_name => rt.propagations
  }

  transit_gateway_attachment_id  = each.value[0] # loop if multiple
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.this[each.key].id
}

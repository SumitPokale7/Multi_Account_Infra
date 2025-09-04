output "security_route_table_id" {
  description = "ID of the security route table"
  value       = var.create_security_route_table ? aws_ec2_transit_gateway_route_table.security[0].id : null
}

output "production_route_table_id" {
  description = "ID of the production route table"
  value       = var.create_production_route_table ? aws_ec2_transit_gateway_route_table.production[0].id : null
}

output "development_route_table_id" {
  description = "ID of the development route table"
  value       = var.create_development_route_table ? aws_ec2_transit_gateway_route_table.development[0].id : null
}

output "route_table_ids" {
  description = "Map of all created route table IDs"
  value = {
    security    = var.create_security_route_table ? aws_ec2_transit_gateway_route_table.security[0].id : null
    production  = var.create_production_route_table ? aws_ec2_transit_gateway_route_table.production[0].id : null
    development = var.create_development_route_table ? aws_ec2_transit_gateway_route_table.development[0].id : null
  }
}

output "route_table_arns" {
  description = "Map of all created route table ARNs"
  value = {
    security    = var.create_security_route_table ? aws_ec2_transit_gateway_route_table.security[0].arn : null
    production  = var.create_production_route_table ? aws_ec2_transit_gateway_route_table.production[0].arn : null
    development = var.create_development_route_table ? aws_ec2_transit_gateway_route_table.development[0].arn : null
  }
}

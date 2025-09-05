output "transit_gateway_route_table_ids" {
  description = "Map of Transit Gateway Route Table IDs"
  value       = { for k, v in aws_ec2_transit_gateway_route_table.this : k => v.id }
}

output "transit_gateway_route_table_associations" {
  description = "Map of TGW Route Table Associations"
  value       = { for k, v in aws_ec2_transit_gateway_route_table_association.assoc : k => v.transit_gateway_attachment_id }
}

output "transit_gateway_route_table_propagations" {
  description = "Map of TGW Route Table Propagations"
  value       = { for k, v in aws_ec2_transit_gateway_route_table_propagation.prop : k => v.transit_gateway_attachment_id }
}

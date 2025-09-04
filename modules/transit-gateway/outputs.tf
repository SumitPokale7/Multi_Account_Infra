# modules/transit-gateway/outputs.tf

output "transit_gateway_id" {
  description = "ID of the Transit Gateway"
  value       = aws_ec2_transit_gateway.main.id
}

output "transit_gateway_arn" {
  description = "ARN of the Transit Gateway"
  value       = aws_ec2_transit_gateway.main.arn
}

output "transit_gateway_owner_id" {
  description = "Owner ID of the Transit Gateway"
  value       = aws_ec2_transit_gateway.main.owner_id
}

output "transit_gateway_association_default_route_table_id" {
  description = "Identifier of the default association route table"
  value       = aws_ec2_transit_gateway.main.association_default_route_table_id
}

output "transit_gateway_propagation_default_route_table_id" {
  description = "Identifier of the default propagation route table"
  value       = aws_ec2_transit_gateway.main.propagation_default_route_table_id
}

output "ram_resource_share_id" {
  description = "ID of the RAM resource share"
  value       = var.enable_cross_account_sharing ? aws_ram_resource_share.tgw[0].id : null
}

output "ram_resource_share_arn" {
  description = "ARN of the RAM resource share"
  value       = var.enable_cross_account_sharing ? aws_ram_resource_share.tgw[0].arn : null
}

output "flow_logs_log_group_name" {
  description = "Name of the CloudWatch log group for flow logs"
  value       = var.enable_flow_logs ? aws_cloudwatch_log_group.tgw_flow_logs[0].name : null
}

output "flow_logs_iam_role_arn" {
  description = "ARN of the IAM role for flow logs"
  value       = var.enable_flow_logs ? aws_iam_role.flow_logs[0].arn : null
}


# Output the VPC endpoint IDs
output "ssm_vpc_endpoint_ids" {
  description = "IDs of the SSM VPC endpoints"
  value = var.create_ssm_endpoint_service ? {
    ssm         = aws_vpc_endpoint.ssm_services["ssm"].id
    ssmmessages = aws_vpc_endpoint.ssm_services["ssmmessages"].id
    ec2messages = aws_vpc_endpoint.ssm_services["ec2messages"].id
  } : {}
}

# Output the VPC endpoint DNS names
output "ssm_vpc_endpoint_dns_names" {
  description = "DNS names of the SSM VPC endpoints"
  value = var.create_ssm_endpoint_service ? {
    for service, endpoint in aws_vpc_endpoint.ssm_services : 
    service => endpoint.dns_entry
  } : {}
}

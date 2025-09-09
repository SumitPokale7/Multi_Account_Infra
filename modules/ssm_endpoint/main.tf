terraform {
  required_version = ">= 1.9.7, < 1.10.0"
}

# using for_each for multiple services
locals {
  ssm_services = var.create_ssm_endpoint_service ? [
    "ssm",
    "ssmmessages", 
    "ec2messages"
  ] : []
}

resource "aws_vpc_endpoint" "ssm_services" {
  for_each = toset(local.ssm_services)

  vpc_endpoint_type   = "Interface"
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.${each.value}"

  private_dns_enabled = true
  subnet_ids          = var.subnet_ids
  security_group_ids  = var.security_group_ids

  tags = {
    Name = "${each.value}-endpoint"
  }
}

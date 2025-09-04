include "root" {
  path = find_in_parent_folders("terragrunt.hcl")
}

terraform {
  source = "../../../../../modules/vpc"
}

dependency "tgw" {
  config_path = "../../../networking/transit-gateway"
  
  mock_outputs = {
    transit_gateway_id = "tgw-mockid12345"
  }
}

inputs = {
  vpc_cidr = "10.4.0.0/16"
  vpc_name = "Endpoints_VPC"

  private_subnets = [
    { cidr = "10.4.0.0/24", az = "us-east-2a", purpose = "tgw" },
    { cidr = "10.4.1.0/24", az = "us-east-2b", purpose = "tgw" },
    { cidr = "10.4.2.0/24", az = "us-east-2a", purpose = "ssm_vpc_endpoint" },
    { cidr = "10.4.3.0/24", az = "us-east-2b", purpose = "ssm_vpc_endpoint" }
  ]

  attach_to_tgw      = true
  transit_gateway_id = dependency.tgw.outputs.transit_gateway_id
  
  common_tags = {
    Environment = "prod"
    VPCType     = "Endpoints"
    Project     = "Networking"
    Account     = "firewall-admin"
  }
}

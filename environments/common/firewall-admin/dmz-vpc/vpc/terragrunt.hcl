terraform {
  source = "../../../../../modules/vpc"
}

include "root" {
  path = find_in_parent_folders("terragrunt.hcl")
}

dependency "tgw" {
  config_path = "../../../networking/transit-gateway"
  
  mock_outputs = {
    transit_gateway_id = "tgw-mockid12345"
  }
}

inputs = {
  vpc_name   = "DMZ_VPC"
  vpc_cidr   = "10.1.0.0/16"

  public_subnets = [
    { cidr = "10.1.0.0/24", az = "us-east-2a" },
    { cidr = "10.1.1.0/24", az = "us-east-2b" }
  ]

  private_subnets = [
    { cidr = "10.1.10.0/24", az = "us-east-2a" , purpose = "gwlbe" },
    { cidr = "10.1.11.0/24", az = "us-east-2b", purpose = "gwlbe" },
    { cidr = "10.1.12.0/24", az = "us-east-2a", purpose = "tgw" },
    { cidr = "10.1.13.0/24", az = "us-east-2b", purpose = "tgw" }
  ]
  
  create_igw         = true
  # TGW attachment
  attach_to_tgw      = true
  transit_gateway_id = dependency.tgw.outputs.transit_gateway_id

  common_tags = {
    Environment = "DMZ"
    Owner       = "Devops-Team"
    VpcType     = "build-infrastructure"
  }
}

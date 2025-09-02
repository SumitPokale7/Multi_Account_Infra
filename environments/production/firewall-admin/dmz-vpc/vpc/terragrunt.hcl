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
  region     = "us-east-2"
  account_id = "337537076454"

  vpc_name   = "DMZ-VPC"
  vpc_cidr   = "10.1.0.0/16"

  public_subnets = [
    { cidr = "10.1.0.0/24", az = "us-east-2a" },
    { cidr = "10.1.1.0/24", az = "us-east-2b" }
  ]

  private_subnets = [
    { cidr = "10.1.10.0/24", az = "us-east-2a" },
    { cidr = "10.1.11.0/24", az = "us-east-2b" },
    { cidr = "10.1.12.0/24", az = "us-east-2a" },
    { cidr = "10.1.13.0/24", az = "us-east-2b" }
  ]
  
  # TGW attachment
  # attach_to_tgw      = true
  # transit_gateway_id = dependency.tgw.outputs.transit_gateway_id
  # transit_gateway_id = "tgw-01266b545aad495fb"
  create_igw = true
  common_tags = {
    Environment = "DMZ"
    Owner       = "Devops-Team"
    VpcType     = "build-infrastructure"
  }
}

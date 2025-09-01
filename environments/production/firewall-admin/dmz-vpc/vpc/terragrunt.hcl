terraform {
  source = "../../../../../modules/vpc"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
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

  vpc_name   = "TeamCity-VPC"
  vpc_cidr   = "10.1.0.0/16"
  
  private_subnets = [
    { cidr = "10.102.21.0/24", az = "us-east-2a" },
    { cidr = "10.102.22.0/24", az = "us-east-2b" },
    { cidr = "10.102.31.0/24", az = "us-east-2a" },
    { cidr = "10.102.32.0/24", az = "us-east-2b" },
  ]

  public_subnets = [
    { cidr = "10.1.0.0/24", az = "us-east-2a" },
    { cidr = "10.1.1.0/24", az = "us-east-2b" }
  ]
  
  # TGW attachment
  attach_to_tgw      = true
  # transit_gateway_id = dependency.tgw.outputs.transit_gateway_id
  transit_gateway_id = "tgw-01266b545aad495fb"
  
  common_tags = {
    Environment = "DMZ"
    Owner       = "Devops-Team"
    VpcType     = "build-infrastructure"
  }
}

terraform {
  source = "../../../modules/vpc"
}

include "root" {
  path = find_in_parent_folders()
}

dependency "tgw" {
  config_path = "../networking/transit-gateway"
  
  mock_outputs = {
    transit_gateway_id = "tgw-mockid12345"
  }
}

inputs = {
  region     = local.region
  account_id = local.account_id

  vpc_name   = "TeamCity-VPC"
  vpc_cidr   = "172.30.0.0/16"
  
  private_subnets = [
    { cidr = "172.30.0.0/24", az = "us-east-2a" },
    { cidr = "172.30.1.0/24", az = "us-east-2b" },
    { cidr = "172.30.2.0/24", az = "us-east-2c" }
  ]
  
  # TGW attachment
  attach_to_tgw      = true
  transit_gateway_id = dependency.tgw.outputs.transit_gateway_id
  
  common_tags = {
    Environment = "TeamCity"
    Project     = "teamcity"
    Owner       = "devops-team"
    VpcType     = "build-infrastructure"
  }
}

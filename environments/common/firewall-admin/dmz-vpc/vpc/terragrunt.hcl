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
  vpc_name   = "DMZ_VPC"
  vpc_cidr   = "10.30.0.0/16"

  public_subnets = [
    { cidr = "10.30.5.0/24", az = "us-east-2a" },
    { cidr = "10.30.6.0/24", az = "us-east-2b" }
  ]

  private_subnets = [
    { cidr = "10.30.2.0/24", az = "us-east-2a", purpose = "tgw" },
    { cidr = "10.30.4.0/24", az = "us-east-2b", purpose = "tgw" },
    { cidr = "10.30.3.0/24", az = "us-east-2b", purpose = "gwlbe" },
    { cidr = "10.30.1.0/24", az = "us-east-2a", purpose = "gwlbe" }
  ]
  
  create_igw         = true
  # TGW attachment
  attach_to_tgw      = true
  transit_gateway_id = dependency.tgw.outputs.transit_gateway_id

  tgw_routes = {
    MezzoBeta        = "10.10.0.0/16"
    MezzoEval        = "10.11.0.0/16"
    SmartVMA         = "10.12.0.0/16"
    FullAdv          = "10.20.0.0/16"
    MezzoProd        = "10.21.0.0/16"
    TeamCity         = "172.30.0.0/16"
    Endpoints        = "10.31.0.0/16"
    SecurityInbound  = "10.32.0.0/16"
    SecurityOutbound = "10.33.0.0/16"
  }

  common_tags = {
    Environment = "common"
    Project     = "dmz-vpc"
    ManagedBy   = "terraform"
    Owner       = "devops-team"
  }
}

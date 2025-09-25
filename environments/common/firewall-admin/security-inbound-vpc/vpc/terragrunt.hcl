include "root" {
  path = find_in_parent_folders("root.hcl")
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
  vpc_cidr = "10.32.0.0/16"
  vpc_name = "Security_Inbound_VPC"

  private_subnets = [
    { cidr = "10.32.1.0/24", az = "us-east-2a", purpose = "tgw" },
    { cidr = "10.32.2.0/24", az = "us-east-2a", purpose = "gwlb" },
    { cidr = "10.32.3.0/24", az = "us-east-2a", purpose = "firewall" },

    { cidr = "10.32.4.0/24", az = "us-east-2b", purpose = "tgw" },
    { cidr = "10.32.5.0/24", az = "us-east-2b", purpose = "gwlb" },
    { cidr = "10.32.6.0/24", az = "us-east-2b", purpose = "firewall" },
  ]

  attach_to_tgw = true
  transit_gateway_id = dependency.tgw.outputs.transit_gateway_id

  tgw_routes = {
    MezzoBeta        = "10.10.0.0/16"
    MezzoEval        = "10.11.0.0/16"
    SmartVMA         = "10.12.0.0/16"
    FullAdv          = "10.20.0.0/16"
    MezzoProd        = "10.21.0.0/16"
    DMZ              = "10.30.0.0/16"
    Endpoints        = "10.31.0.0/16"
    SecurityOutbound = "10.33.0.0/16"
  }
  
  common_tags = {
    Environment = "common"
    ManagedBy   = "terraform"
    Owner       = "devops-team"
    Project     = "security-inbound"
  }
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../modules/vpc"
}

dependency "tgw" {
  config_path = "../../../common/networking/transit-gateway"
  
  mock_outputs = {
    transit_gateway_id = "tgw-mockid12345"
  }
}

inputs = {
  vpc_cidr   = "10.11.0.0/16"
  vpc_name   = "Mezzo_Eval_VPC"

  private_subnets = [
    { cidr = "10.11.1.0/24", az = "us-east-2a", purpose = "db" },
    { cidr = "10.11.2.0/24", az = "us-east-2a", purpose = "app" },
    { cidr = "10.11.3.0/24", az = "us-east-2a", purpose = "tgw" },

    { cidr = "10.11.4.0/24", az = "us-east-2b", purpose = "db" },
    { cidr = "10.11.5.0/24", az = "us-east-2b", purpose = "app" },
    { cidr = "10.11.6.0/24", az = "us-east-2b", purpose = "tgw" },
  ]

  attach_to_tgw      = true
  transit_gateway_id = dependency.tgw.outputs.transit_gateway_id

  tgw_routes = {
    MezzoBeta        = "10.10.0.0/16"
    SmartVMA         = "10.12.0.0/16"
    FullAdv          = "10.20.0.0/16"
    MezzoProd        = "10.21.0.0/16"
    TeamCity         = "172.30.0.0/16"
    DMZ              = "10.30.0.0/16"
    Endpoints        = "10.31.0.0/16"
    SecurityInbound  = "10.32.0.0/16"
    SecurityOutbound = "10.33.0.0/16"
  }
  
  common_tags = {
    Environment = "Dev"
    ManagedBy   = "terraform"
    Project     = "mezzo-eval"
    Owner       = "devops-team"
 }
}

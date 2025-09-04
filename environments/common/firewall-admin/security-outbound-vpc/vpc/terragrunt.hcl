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
  vpc_cidr = "10.3.0.0/16"
  vpc_name = "Security_Outbound_VPC"

  public_subnets = [
    { cidr = "10.3.1.0/24", az = "us-east-2a", purpose = "nat" },
    { cidr = "10.3.2.0/24", az = "us-east-2b", purpose = "nat" }
  ]

  private_subnets = [
    { cidr = "10.3.21.0/24", az = "us-east-2a", purpose = "tgw" },
    { cidr = "10.3.22.0/24", az = "us-east-2b", purpose = "tgw" },
    { cidr = "10.3.41.0/24", az = "us-east-2a", purpose = "gwlb" },
    { cidr = "10.3.42.0/24", az = "us-east-2b", purpose = "gwlb" },
    { cidr = "10.3.31.0/24", az = "us-east-2a", purpose = "gwlbe" },
    { cidr = "10.3.32.0/24", az = "us-east-2b", purpose = "gwlbe" },
    { cidr = "10.3.11.0/24", az = "us-east-2a", purpose = "firewall" },
    { cidr = "10.3.12.0/24", az = "us-east-2b", purpose = "firewall" }
  ]
  
  create_igw         = true
  create_nat_gateway = true
  attach_to_tgw      = true
  transit_gateway_id = dependency.tgw.outputs.transit_gateway_id
  
  common_tags = {
    Environment = "Prod"
    Project     = "SecurityOutbound"
    Account     = "firewall-admin" 
    VPCType     = "SecurityOutbound"
  }
}
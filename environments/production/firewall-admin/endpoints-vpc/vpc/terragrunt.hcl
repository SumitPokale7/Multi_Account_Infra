terraform {
  source = "../../../../../modules/vpc"
}

inputs = {
  vpc_name = "Endpoints_VPC"
  vpc_cidr = "10.4.0.0/16"

  private_subnets = [
    { cidr = "10.4.0.0/24", az = "us-east-2a", purpose = "tgw" },
    { cidr = "10.4.1.0/24", az = "us-east-2b", purpose = "tgw" },
    { cidr = "10.4.2.0/24", az = "us-east-2a", purpose = "ssm_vpc_endpoint" },
    { cidr = "10.4.3.0/24", az = "us-east-2b", purpose = "ssm_vpc_endpoint" }
  ]

  attach_to_tgw = true
  transit_gateway_id = 
  
  common_tags = {
    Environment = "prod"
    VPCType     = "Endpoints"
    Project     = "Networking"
    Account     = "firewall-admin"
  }
}

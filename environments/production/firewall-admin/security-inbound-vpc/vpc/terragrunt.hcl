terraform {
  source = "../../../modules/vpc"
}

inputs = {
  vpc_name = "Security_Inbound_VPC"
  vpc_cidr = "10.101.0.0/16"
  
  private_subnets = [
    { cidr = "10.101.1.0/24", az = "us-east-2a" },   # Network Firewall
    { cidr = "10.101.2.0/24", az = "us-east-2b" },   # Network Firewall
    { cidr = "10.101.11.0/24", az = "us-east-2a" },  # TGW Attachment
    { cidr = "10.101.12.0/24", az = "us-east-2b" },  # TGW Attachment
    { cidr = "10.101.21.0/24", az = "us-east-2a" },  # Inbound GWLB
    { cidr = "10.101.22.0/24", az = "us-east-2b" }   # Inbound GWLB
  ]
  
  attach_to_tgw = true
  transit_gateway_id = "tgw-xxxxxxxxx"
  
  common_tags = {
    Environment = "shared"
    Account     = "firewall-admin"
    Project     = "Networking"
    VPCType     = "SecurityInbound"
  }
}

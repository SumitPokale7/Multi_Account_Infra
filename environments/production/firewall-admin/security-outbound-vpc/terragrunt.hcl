terraform {
  source = "../../../modules/vpc"
}

inputs = {
  vpc_name = "Security_Outbound_VPC"
  vpc_cidr = "10.102.0.0/16"
  
  public_subnets = [
    { cidr = "10.102.1.0/24", az = "us-east-2a" },   # NAT Gateway
    { cidr = "10.102.2.0/24", az = "us-east-2b" }    # NAT Gateway
  ]
  
  private_subnets = [
    { cidr = "10.102.11.0/24", az = "us-east-2a" },  # Network Firewall
    { cidr = "10.102.12.0/24", az = "us-east-2b" },  # Network Firewall
    { cidr = "10.102.21.0/24", az = "us-east-2a" },  # TGW Attachment
    { cidr = "10.102.22.0/24", az = "us-east-2b" },  # TGW Attachment
    { cidr = "10.102.31.0/24", az = "us-east-2a" },  # Inbound GWLBe
    { cidr = "10.102.32.0/24", az = "us-east-2b" },  # Inbound GWLBe
    { cidr = "10.102.41.0/24", az = "us-east-2a" },  # Inbound GWLB
    { cidr = "10.102.42.0/24", az = "us-east-2b" }   # Inbound GWLB
  ]
  
  create_igw         = true
  create_nat_gateway = true
  attach_to_tgw      = true
  transit_gateway_id = "tgw-xxxxxxxxx"
  
  common_tags = {
    Environment = "shared"
    Project     = "Networking"
    Account     = "firewall-admin" 
    VPCType     = "SecurityOutbound"
  }
}
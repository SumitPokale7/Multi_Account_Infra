terraform {
  source = "../../../../../modules/vpc"
}

inputs = {
  vpc_name = "Security_Inbound_VPC"
  vpc_cidr = "10.2.0.0/16"
  
  private_subnets = [
    { cidr = "10.101.11.0/24", az = "us-east-2a", purpose = "tgw"  },     # TGW Attachment
    { cidr = "10.101.12.0/24", az = "us-east-2b", purpose = "tgw"  },     # TGW Attachment
    { cidr = "10.101.22.0/24", az = "us-east-2b", purpose = "gwlb"  },    # Inbound GWLB
    { cidr = "10.101.21.0/24", az = "us-east-2a", purpose = "gwlb"  },    # Inbound GWLB
    { cidr = "10.101.1.0/24", az = "us-east-2a", purpose = "firewall" },  # Network Firewall
    { cidr = "10.101.2.0/24", az = "us-east-2b", purpose = "firewall"  }, # Network Firewall
  ]
  
  attach_to_tgw = true
  transit_gateway_id = "tgw-xxxxxxxxx"
  
  common_tags = {
    Environment = "shared"
    ManagedBy   = "terraform"
    Project     = "Networking"
    Account     = "firewall-admin"
    VPCType     = "SecurityInbound"
  }
}

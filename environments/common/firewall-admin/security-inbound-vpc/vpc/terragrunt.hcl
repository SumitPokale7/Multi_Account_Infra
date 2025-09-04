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
  vpc_name = "Security_Inbound_VPC"
  vpc_cidr = "10.2.0.0/16"
  
  private_subnets = [
    { cidr = "10.2.11.0/24", az = "us-east-2a", purpose = "tgw"  },     # TGW Attachment
    { cidr = "10.2.12.0/24", az = "us-east-2b", purpose = "tgw"  },     # TGW Attachment
    { cidr = "10.2.22.0/24", az = "us-east-2b", purpose = "gwlb"  },    # Inbound GWLB
    { cidr = "10.2.21.0/24", az = "us-east-2a", purpose = "gwlb"  },    # Inbound GWLB
    { cidr = "10.2.1.0/24",  az = "us-east-2a", purpose = "firewall" }, # Network Firewall
    { cidr = "10.2.2.0/24",  az = "us-east-2b", purpose = "firewall" }, # Network Firewall
  ]


  attach_to_tgw = true
  transit_gateway_id = dependency.tgw.outputs.transit_gateway_id
  
  common_tags = {
    Environment = "shared"
    ManagedBy   = "terraform"
    Project     = "Networking"
    Account     = "firewall-admin"
    VPCType     = "SecurityInbound"
  }
}

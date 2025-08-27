# ===============================================
# Networking Account - Transit Gateway Creation
# File: networking-account/us-east-2/transit-gateway/terragrunt.hcl
# ===============================================

terraform {
  source = "../../../modules/transit-gateway"
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  tgw_name        = "central-tgw"
  description     = "Central Transit Gateway for multi-account connectivity"
  amazon_side_asn = 64512
  
  # Disable default route tables to use custom ones
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  
  # Cross-account sharing configuration
  enable_cross_account_sharing = true
  ram_share_name              = "central-tgw-share"
  shared_account_ids = [
    "111111111111", # MezzoEval Account
    "222222222222", # SmartVMAEval Account
    "333333333333", # FullADVProduction Account
    "444444444444", # MezzoProduction Account
    "555555555555", # MezzoBeta Account
    "666666666666", # Firewall Admin Account
  ]
  
  # Store TGW ID in SSM for reference
  store_in_ssm        = true
  ssm_parameter_name  = "/networking/transit-gateway/id"
  
  # Enable flow logs for monitoring
  enable_flow_logs           = true
  flow_logs_retention_days   = 30
  
  common_tags = {
    Environment   = "networking"
    Project       = "central-connectivity"
    Owner         = "networking-team"
    CostCenter    = "networking"
  }
}

# ===============================================
# Networking Account - TGW Route Configuration
# File: networking-account/us-east-2/transit-gateway-routing/terragrunt.hcl
# ===============================================

terraform {
  source = "../../../modules/transit-gateway-routing"
}

include "root" {
  path = find_in_parent_folders()
}

dependency "tgw" {
  config_path = "../transit-gateway"
  mock_outputs = {
    transit_gateway_id = "tgw-12345"
  }
}

inputs = {
  # Get TGW ID from dependency
  transit_gateway_id = dependency.tgw.outputs.transit_gateway_id
  use_ssm_parameter  = false
  
  # Create route tables for different environments
  create_security_route_table     = true
  create_production_route_table   = true
  create_development_route_table  = true
  
  # Route all traffic through security inspection
  route_production_through_security   = true
  route_development_through_security  = true
  route_internet_through_security     = true
  
  # Isolate environments from each other
  isolate_environments = true
  
  # Define CIDR blocks for each environment
  production_cidrs = [
    "10.1.0.0/16",  # MezzoProduction VPC
    "10.2.0.0/16",  # FullADVProduction VPC
  ]
  
  development_cidrs = [
    "10.10.0.0/16", # MezzoEval VPC
    "10.11.0.0/16", # SmartVMAEval VPC
    "10.12.0.0/16", # MezzoBeta VPC
  ]
  
  security_cidrs = [
    "10.100.0.0/16", # Security Inbound VPC
    "10.101.0.0/16", # Security Outbound VPC
    "10.102.0.0/16", # DMZ VPC
  ]
  
  common_tags = {
    Environment   = "networking"
    Project       = "tgw-routing"
    Owner         = "networking-team"
  }
}


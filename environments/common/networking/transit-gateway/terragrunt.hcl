terraform {
  source = "../../../../modules/transit-gateway"
}

include "root" {
  path = find_in_parent_folders("terragrunt.hcl")
}

inputs = {
  amazon_side_asn = 64512
  tgw_name        = "central-tgw"
  description     = "Central Transit Gateway for multi-account connectivity"
  
  # Disable default route tables to use custom ones
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  
  # Cross-account sharing configuration
  enable_cross_account_sharing = true
  ram_share_name              = "central-tgw-share"

  shared_account_ids = [
    "337537076454", # Firewall Admin Account
  ]
  
  # Enable flow logs for monitoring
  flow_logs_retention_days   = 30
  enable_flow_logs           = true
  
  common_tags = {
    Environment   = "networking"
    Owner         = "networking-team"
    CostCenter    = "networking"
    Project       = "central-connectivity"
  }
}

# terraform {
#   source = "../../../modules/transit-gateway-routing"
# }

# include "root" {
#   path = find_in_parent_folders()
# }

# dependency "tgw" {
#   config_path = "../transit-gateway"
#   mock_outputs = {
#     transit_gateway_id = "tgw-12345"
#   }
# }

# inputs = {
#   # Get TGW ID from dependency
#   transit_gateway_id = dependency.tgw.outputs.transit_gateway_id

#   # Create route tables for different environments
#   create_security_route_table     = true
#   create_production_route_table   = true
#   create_development_route_table  = true

#   # Route all traffic through security inspection
#   route_production_through_security   = true
#   route_development_through_security  = true
#   route_internet_through_security     = true

#   # Isolate environments from each other
#   isolate_environments = true

#   # CIDR definitions
#   production_cidrs = [
#     "10.1.0.0/16",
#     "10.2.0.0/16",
#   ]

#   development_cidrs = [
#     "10.10.0.0/16",
#     "10.11.0.0/16",
#   ]

#   security_cidrs = [
#     "10.100.0.0/16",
#     "10.101.0.0/16",
#   ]

#   common_tags = {
#     Environment   = "networking"
#     Project       = "tgw-routing"
#     Owner         = "networking-team"
#   }
# }


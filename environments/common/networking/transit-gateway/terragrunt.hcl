terraform {
  source = "../../../../modules/transit-gateway"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
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
    "390259467653", # Application-Workload-DEV-Account
    "327903111409", # Application-Workload-PROD-Account
  ]
  
  # Enable flow logs for monitoring
  flow_logs_retention_days   = 30
  enable_flow_logs           = true
  
  common_tags = {
    ManagedBy   = "terraform"
    Environment = "networking"
    Owner       = "devops-team"
    Project     = "transit-gateway"
  }
}

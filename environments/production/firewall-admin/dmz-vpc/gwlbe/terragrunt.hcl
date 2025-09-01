include "root" {
  path = find_in_parent_folders("terragrunt.hcl")
}

terraform {
  source = "../../../../../modules/gwlbe"
}

dependency "vpc" {
  config_path = "../vpc"
  
  mock_outputs = {
    vpc_id = "vpc-mockapp2123"
    workload_subnet_ids = ["subnet-work1a", "subnet-work1b", "subnet-work1c"]
    workload_route_table_ids = ["rt-work1a", "rt-work1b", "rt-work1c"]
  }
}

inputs = {
  vpc_id      = dependency.vpc.outputs.vpc_id
  subnet_ids  = dependency.vpc.outputs.workload_subnet_ids
  
  # External security service
  service_name = "com.amazonaws.vpce.us-east-1.vpce-svc-9876543210fedcba0"
  
  # Multi-AZ route table associations
  route_table_ids = dependency.vpc.outputs.workload_route_table_ids
  
  project_name = "app2-workload"
  
  tags = {
    Environment   = "prod"
    Project       = "app2"
    Component     = "workload-gwlbe"
    ManagedBy     = "terraform"
    Owner         = "app2-team"
    CostCenter    = "applications"
    Compliance    = "required"
    BackupPolicy  = "daily"
  }
}
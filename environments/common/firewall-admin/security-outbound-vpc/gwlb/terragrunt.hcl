include "root" {
  path = find_in_parent_folders("terragrunt.hcl")
}

terraform {
  source = "../../../../../modules/gwlb"
}

dependency "vpc" {
  config_path = "../vpc"
  
  mock_outputs = {
    vpc_id = "vpc-mockgwlb123"
  }
}

inputs = {
  vpc_id     = dependency.vpc.outputs.vpc_id
  subnet_ids = dependency.vpc.outputs.private_subnet_ids["gwlb"]
  target_ids = []
  
  project_name = "security-outbound"
  
  # Target Group Configuration
  target_group_port = 6081

  # Health Check Configuration
  healthy_threshold        = 3
  unhealthy_threshold      = 3
  health_check_timeout     = 6
  health_check_interval    = 10
  health_check_path        = "/"
  health_check_port        = "80"
  health_check_enabled     = true
  health_check_protocol    = "HTTP"

  enable_deletion_protection           = true
  create_endpoint_service              = true
  endpoint_service_acceptance_required = false
  
  tags = {
    Environment = "prod"
    ManagedBy   = "terraform"
    Owner       = "devops-team"
    Project     = "security-outbound"
    Component   = "gateway-load-balancer"
  }
}

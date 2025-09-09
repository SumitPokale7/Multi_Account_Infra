include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../../modules/gwlb"
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    vpc_id             = "mock-vpc-output"
    private_subnet_ids = {
      gwlb = ["subnet-12345", "subnet-67890"]
    }
  }
}

inputs = {
  vpc_id     = dependency.vpc.outputs.vpc_id
  subnet_ids = dependency.vpc.outputs.private_subnet_ids["gwlb"]
  target_ids = []
  
  project_name = "security-inbound"
  
  target_group_port = 6081

  healthy_threshold        = 2
  unhealthy_threshold      = 2
  health_check_interval    = 30
  health_check_enabled     = true
  health_check_protocol    = "TCP"

  create_endpoint_service              = true
  enable_deletion_protection           = false
  endpoint_service_acceptance_required = false
  
  tags = {
    Environment = "prod"
    ManagedBy   = "terraform"
    Owner       = "devops-team"
    Project     = "security-inbound"
    Component   = "security-inbound-gateway-lb"
  }
}
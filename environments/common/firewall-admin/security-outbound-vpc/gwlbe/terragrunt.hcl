include "root" {
  path = find_in_parent_folders("terragrunt.hcl")
}

terraform {
  source = "../../../../../modules/gwlbe"
}

dependency "vpc" {
  config_path = "../vpc"
  
  mock_outputs = {
    vpc_id = "vpc-mocksec123"
  }
}

dependency "gwlb" {
  config_path = "../gwlb"
  
  mock_outputs = {
    endpoint_service_name = "com.amazonaws.vpce.us-east-1.vpce-svc-mockservice"
  }
}

inputs = {
  project_name = "security-outbound"
  vpc_id       = dependency.vpc.outputs.vpc_id
  subnet_ids   = dependency.vpc.outputs.private_subnet_ids["gwlbe"]

  service_name = dependency.gwlb.outputs.endpoint_service_name
  
  tags = {
    Environment = "prod"
    ManagedBy   = "terraform"
    Owner       = "devops-team"
    Project     = "security-outbound"
    Component   = "security-outbound-gateway-lb-endpoint"
  }
}
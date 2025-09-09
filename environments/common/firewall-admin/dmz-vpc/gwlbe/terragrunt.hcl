include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../../modules/gwlbe"
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    vpc_id            = "mock-vpc-output"
    private_subnet_ids = {
      gwlbe = ["subnet-12345", "subnet-67890"]
    }
  }
}

dependency "gwlb" {
  config_path = "../../security-inbound-vpc/gwlb"
  
  mock_outputs = {
    endpoint_service_name = "com.amazonaws.vpce.us-east-1.vpce-svc-mockservice"
  }
}

inputs = {
  project_name = "dmz"
  vpc_id       = dependency.vpc.outputs.vpc_id
  service_name = dependency.gwlb.outputs.endpoint_service_name
  subnet_ids   = dependency.vpc.outputs.private_subnet_ids["gwlbe"]

  tags = {
    Environment   = "prod"
    ManagedBy     = "terraform"
    Owner         = "devops-team"
  }
}

include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/gwlb_endpoint"
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  name         = "dmz-gwlbe"
  vpc_id       = dependency.vpc.outputs.vpc_id
  subnet_ids   = dependency.vpc.outputs.private_subnet_ids["gwlb"]
  service_name = "com.amazonaws.vpce.us-east-1.vpce-svc-1234567890abcdef"
  tags = {
    Environment = "dmz"
  }
}

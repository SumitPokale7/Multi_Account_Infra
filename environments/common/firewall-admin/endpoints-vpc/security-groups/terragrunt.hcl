include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../../modules/security_groups"
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    vpc_id            = "mock-vpc-output"
    vpc_cidr_block    = "0.0.0.0/0" 
  }
}

inputs = {
  vpc_id               = dependency.vpc.outputs.vpc_id
  security_group_name  = "endpoints_vpc"
  security_groups = {
    ssm_sg = {
      ingress = [
        { from_port = 443, to_port = 443, protocol = "tcp", cidr_blocks = [dependency.vpc.outputs.vpc_cidr_block] }
      ]
      egress = [
        { from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"] }
      ]
    }
  }
}

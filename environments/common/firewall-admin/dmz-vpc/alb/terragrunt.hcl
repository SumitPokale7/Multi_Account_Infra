include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../../modules/alb"
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    vpc_id            = "mock-vpc-output"
    public_subnet_ids = ["mock-public-subnet-id"]
  }
}

dependency "sg" {
  config_path = "../security-groups"

  mock_outputs = {
    sg_ids = {
      alb_sg = "mock-security_groups-output"
    }
  }
}

inputs = {
  internal           = false
  target_group       = false

  create_target_group = false
  listener_port       = 80
  listener_protocol   = "HTTP"
  name                = "dmz-alb"
  vpc_id              = dependency.vpc.outputs.vpc_id
  security_group_ids  = values(dependency.sg.outputs.sg_ids)
  subnet_ids          = dependency.vpc.outputs.public_subnet_ids

  tags = {
    Environment = "dmz"
  }
}

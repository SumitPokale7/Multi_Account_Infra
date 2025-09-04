include "root" {
  path = find_in_parent_folders("terragrunt.hcl")
}

terraform {
  source = "../../../../../modules/alb"
}

dependency "vpc" {
  config_path = "../vpc"
}

dependency "sg" {
  config_path = "../security-groups"
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

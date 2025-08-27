include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/alb"
}

dependency "vpc" {
  config_path = "../vpc"
}

dependency "sg" {
  config_path = "../security-groups"
}

inputs = {
  name               = "dmz-alb"
  vpc_id             = dependency.vpc.outputs.vpc_id
  subnet_ids         = dependency.vpc.outputs.public_subnet_ids
  security_group_ids = [dependency.sg.outputs.sg_ids.alb_sg]
  listener_port      = 80
  listener_protocol  = "HTTP"
  tags = {
    Environment = "dmz"
  }
}

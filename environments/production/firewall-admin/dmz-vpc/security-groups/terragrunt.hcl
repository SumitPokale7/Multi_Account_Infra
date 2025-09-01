include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../../modules/security_groups"
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  vpc_id = dependency.vpc.outputs.vpc_id

  security_groups = {
    alb_sg = {
      ingress = [
        { from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
        { from_port = 443, to_port = 443, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] }
      ]
      egress = [
        { from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"] }
      ]
    }
    gwlb_sg = {
      ingress = [
        { from_port = 6081, to_port = 6081, protocol = "udp", cidr_blocks = ["10.0.0.0/8"] }
      ]
      egress = [
        { from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"] }
      ]
    }
  }
}

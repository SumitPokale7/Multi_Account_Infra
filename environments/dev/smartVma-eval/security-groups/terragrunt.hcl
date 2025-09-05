include "root" {
  path = find_in_parent_folders("terragrunt.hcl")
}

terraform {
  source = "../../../../modules/security_groups"
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  vpc_id              = dependency.vpc.outputs.vpc_id
  security_group_name = "smartvma-eval"  
  security_groups = {
    rds-sg = {
      ingress = [
        { from_port = 3306, to_port = 3306, protocol = "tcp", cidr_blocks = [dependency.vpc.outputs.vpc_cidr_block] }
      ]
      egress = [
        { from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"] }
      ]
    }
    ec2-sg = {
      ingress = [
        { from_port = 22, to_port = 22, protocol = "tcp", cidr_blocks = [dependency.vpc.outputs.vpc_cidr_block] }
      ]
      egress = [
        { from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"] }
      ]
    }
  }
}

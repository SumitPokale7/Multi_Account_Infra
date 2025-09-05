# terragrunt.hcl
include "root" {
  path = find_in_parent_folders("terragrunt.hcl")
}

terraform {
  source = "../../../../modules/ec2"
}

dependency "vpc" {
  config_path = "../vpc"
}

dependency "security_groups" {
  config_path = "../security-groups"
}

inputs = {
  key_name           = "smartvma-eval-dev-key"
  ami                = "ami-0b016c703b95ecbe4"

  project            = "smartvma-eval"

  instances = [
    {
      instance_type       = "t2.micro"
      name                = "smartvma-eval-1"
      subnet_id           = dependency.vpc.outputs.private_subnet_ids["app"][0]
      security_group_ids  = [dependency.security_groups.outputs.sg_ids["ec2-sg"]]
    },
    {
      instance_type       = "t2.micro"
      name                = "smartvma-eval-2"
      subnet_id           = dependency.vpc.outputs.private_subnet_ids["app"][1]
      security_group_ids  = [dependency.security_groups.outputs.sg_ids["ec2-sg"]]
    },
  ]

  tags = {
    Environment = "dev"
    Account     = "smartvma-eval"
    Project     = "mezzo"
    ManagedBy   = "terraform"
  }
}

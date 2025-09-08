# terragrunt.hcl
include "root" {
  path = find_in_parent_folders("root.hcl")
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
  key_name           = "teamcity-dev-key"
  ami                = "ami-0b016c703b95ecbe4"

  project            = "teamcity"

  instances = [
    {
      instance_type       = "t2.micro"
      name                = "teamcity-1"
      subnet_id           = dependency.vpc.outputs.private_subnet_ids["tgw"][0]
      security_group_ids  = [dependency.security_groups.outputs.sg_ids["ec2-sg"]]
    },
    {
      instance_type       = "t2.micro"
      name                = "teamcity-2"
      subnet_id           = dependency.vpc.outputs.private_subnet_ids["tgw"][0]
      security_group_ids  = [dependency.security_groups.outputs.sg_ids["ec2-sg"]]
    },
    {
      instance_type       = "t2.micro"
      name                = "teamcity-3"
      subnet_id           = dependency.vpc.outputs.private_subnet_ids["tgw"][0]
      security_group_ids  = [dependency.security_groups.outputs.sg_ids["ec2-sg"]]
    }
  ]

  tags = {
    Environment = "dev"
    Account     = "teamcity"
    Project     = "mezzo"
    ManagedBy   = "terraform"
  }
}

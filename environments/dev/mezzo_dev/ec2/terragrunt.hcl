# terragrunt.hcl
include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../modules/ec2"
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    private_subnet_ids = {
      app = ["subnet-12345", "subnet-67890"]
    }
  }
}

dependency "security_groups" {
  config_path = "../security-groups"

  mock_outputs = {
    sg_ids = {
      ec2-sg = "mock-security_groups-output"
    }
  }
}

inputs = {
  project            = "mezzo-dev"
  key_name           = "mezzo-dev-dev-key"
  ami                = "ami-0b016c703b95ecbe4"

  instances = [
    {
      instance_type       = "t2.micro"
      name                = "mezzo-dev-1"
      subnet_id           = dependency.vpc.outputs.private_subnet_ids["app"][0]
      security_group_ids  = [dependency.security_groups.outputs.sg_ids["ec2-sg"]]
    },
    {
      instance_type       = "t2.micro"
      name                = "mezzo-dev-2"
      subnet_id           = dependency.vpc.outputs.private_subnet_ids["app"][1]
      security_group_ids  = [dependency.security_groups.outputs.sg_ids["ec2-sg"]]
    },
  ]

  tags = {
    Environment = "dev"
    Account     = "mezzo-dev"
    Project     = "mezzo"
    ManagedBy   = "terraform"
  }
}

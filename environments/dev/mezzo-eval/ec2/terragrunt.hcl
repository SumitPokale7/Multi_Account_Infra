include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/ec2"
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  ami                = "ami-0abcdef1234567890"
  key_name           = "dev-key"
  security_group_ids = ["sg-123456"]

  tags = {
    Environment = "dev"
  }

  instances = [
    {
      name          = "small-1"
      instance_type = "t2.micro"
      subnet_id     = dependency.vpc.outputs.public_subnet_ids[0]
    }
  ]
}


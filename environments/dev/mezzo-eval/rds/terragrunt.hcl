include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/rds"
}

dependency "vpc" {
  config_path = "../vpc"
}

dependency "sg" {
  config_path = "../security-groups"
}

inputs = {
  name                   = "account-db"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.medium"
  allocated_storage      = 20
  max_allocated_storage  = 100
  storage_type           = "gp3"
  username               = "admin"
  password               = "SuperSecretPass123!"
  
  # ✅ Dynamically pull DB subnets from the VPC module
  subnet_ids             = dependency.vpc.outputs.db_private_subnet_ids

  # ✅ Attach SGs created by the SG module
  vpc_security_group_ids = [dependency.sg.outputs.db_sg_id]

  tags = {
    Environment = "dev"
    Account     = "MezzoEval"
  }
}

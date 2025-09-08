include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../modules/rds"
}

dependency "vpc" {
  config_path = "../vpc"
  
  mock_outputs = {
    private_subnet_ids = {
      db = ["subnet-12345", "subnet-67890"]
    }
  }
}

dependency "sg" {
  config_path = "../security-groups"
  
  mock_outputs = {
    sg_ids = {
      rds = "sg-12345"
    }
  }
}

inputs = {
  # Cluster Configuration
  create_rds_cluster     = false  # Set to true when need to create cluster
  
  # Database Configuration
  username               = "admin"
  engine                 = "aurora-mysql"
  name                   = "full-adv-db"
  password               = "SecretPass123!"
  engine_version         = "5.7.mysql_aurora.2.11.0"
  
  # Instance Configuration
  instance_count         = 2
  instance_class         = "db.t3.medium"
  
  # Network Configuration
  vpc_security_group_ids = values(dependency.sg.outputs.sg_ids)
  subnet_ids             = dependency.vpc.outputs.private_subnet_ids["db"]
  
  # Backup Configuration
  backup_retention_period = 7
  skip_final_snapshot     = true

  tags = {
    Environment = "Prod"
    Project     = "FullAdv"
    ManagedBy   = "terraform"
    Account     = "Application-Workload-PROD-Account"
  }
}

include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/application-vpc"
}

dependency "networking" {
  config_path = "../networking"
  mock_outputs = {
    transit_gateway_id = "tgw-mock"
  }
}

dependency "org" {
  config_path = "../organization_account"
}

inputs = {
  region     = "us-east-2"
  account_id = dependency.org.outputs.account_ids["mezzo_eval"]
  assume_role_arn = "arn:aws:iam::${account_id}:role/TerraformExecutionRole"
  
  vpc_config = {
    name                 = "MezzoEval_VPC"
    cidr_block          = "10.20.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support   = true
    
    private_subnets = {
      "app-1" = { cidr = "10.20.1.0/24", az = "us-east-2a" }
      "app-2" = { cidr = "10.20.2.0/24", az = "us-east-2b" }
      "db-1"  = { cidr = "10.20.10.0/24", az = "us-east-2a" }
      "db-2"  = { cidr = "10.20.11.0/24", az = "us-east-2b" }
      "tgw-1" = { cidr = "10.20.20.0/24", az = "us-east-2a" }
      "tgw-2" = { cidr = "10.20.21.0/24", az = "us-east-2b" }
    }
  }
  
  transit_gateway_id = dependency.networking.outputs.transit_gateway_id
  
  application_config = {
    name = "mezzo-eval"
    
    asg_config = {
      min_size         = 1
      max_size         = 5
      desired_capacity = 2
      instance_type    = "t3.medium"
    }
    
    alb_config = {
      name               = "mezzo-eval-alb"
      load_balancer_type = "application"
      scheme            = "internal"
    }
    
    elasticache_config = {
      node_type                = "cache.r6g.large"
      num_cache_nodes          = 2
      parameter_group_name     = "default.redis7"
      port                     = 6379
    }
  }
}

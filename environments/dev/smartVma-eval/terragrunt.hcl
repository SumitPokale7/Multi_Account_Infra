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

inputs = {
  account_id = "222222222222"  # MezzoProduction Account ID
  assume_role_arn = "arn:aws:iam::222222222222:role/TerraformExecutionRole"
  
  vpc_config = {
    name                 = "MezzoProduction_VPC"
    cidr_block          = "10.10.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support   = true
    
    private_subnets = {
      "app-1" = { cidr = "10.10.1.0/24", az = "us-east-2a" }
      "app-2" = { cidr = "10.10.2.0/24", az = "us-east-2b" }
      "db-1"  = { cidr = "10.10.10.0/24", az = "us-east-2a" }
      "db-2"  = { cidr = "10.10.11.0/24", az = "us-east-2b" }
      "tgw-1" = { cidr = "10.10.20.0/24", az = "us-east-2a" }
      "tgw-2" = { cidr = "10.10.21.0/24", az = "us-east-2b" }
    }
  }
  
  transit_gateway_id = dependency.networking.outputs.transit_gateway_id
  
  application_config = {
    name = "mezzo-production"
    
    # Auto Scaling Groups
    asg_config = {
      min_size         = 2
      max_size         = 10
      desired_capacity = 4
      instance_type    = "t3.large"
    }
    
    # Load Balancer
    alb_config = {
      name               = "mezzo-production-alb"
      load_balancer_type = "application"
      scheme            = "internal"
    }
    
    # ElastiCache
    elasticache_config = {
      node_type                = "cache.r6g.large"
      num_cache_nodes          = 3
      parameter_group_name     = "default.redis7"
      port                     = 6379
    }
  }
}

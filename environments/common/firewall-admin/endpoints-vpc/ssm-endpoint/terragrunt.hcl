include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../../modules/ssm_endpoint"
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    vpc_id             = "mock-vpc-output"
    private_subnet_ids = {
      ssm_vpc_endpoint = ["subnet-12345", "subnet-67890"]
    }
  }
}

dependency "sg" {
  config_path = "../security-groups"

  mock_outputs = {
    sg_ids = {
      ssm_sg = "mock-security_groups-output"
    }
  }
}

locals {
  root_config = read_terragrunt_config(find_in_parent_folders("root.hcl"))
  region      = local.root_config.locals.region
}

inputs = {
  create_ssm_endpoint_service = true
  region                      = local.region
  vpc_id                      = dependency.vpc.outputs.vpc_id
  security_group_ids          = values(dependency.sg.outputs.sg_ids)
  subnet_ids                  = dependency.vpc.outputs.private_subnet_ids["ssm_vpc_endpoint"]

  common_tags = {
    Environment = "prod"
    VPCType     = "Endpoints"
    Project     = "Networking"
    Account     = "firewall-admin"
  }
}

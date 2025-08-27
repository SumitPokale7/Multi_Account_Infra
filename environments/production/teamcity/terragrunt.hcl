terraform {
  source = "../../../modules/vpc" # can point to VPC, TGW, etc. per child hcl
}

dependency "org" {
  config_path = "../organization_account"
}

locals {
  region     = "us-east-2"
  account_id = dependency.org.outputs.account_ids["TeamCity"]
}


generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.region}"

  assume_role {
    role_arn     = "arn:aws:iam::${local.account_id}:role/OrganizationAccountAccessRole"
    session_name = "terragrunt"
  }
}
EOF
}


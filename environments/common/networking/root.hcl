# Pin Terragrunt version
terragrunt_version_constraint = "= 0.86.1"

locals {
  region          = "us-east-2"
  account_id      = "635566486216"
  account_name    = "Networking-Account"
}

remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    region         = "us-east-2"
    dynamodb_table = "terraform-locks"  
    bucket         = "global-infra-state-us-east-2"
    key            = "common/networking/${path_relative_to_include()}/terraform.tfstate"
    
    # Cross-account access
    role_arn = "arn:aws:iam::${local.account_id}:role/TerraformStateExecutionRole"
    
    # If using profiles
    # profile = "networking_account"
  }
  
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "aws" {
  region  = "${local.region}"
  # profile = "networking_account"

  assume_role {
    role_arn     = "arn:aws:iam::${local.account_id}:role/TerraformExecutionRole"
    session_name = "TerraformExecution"
  }
}
EOF
}

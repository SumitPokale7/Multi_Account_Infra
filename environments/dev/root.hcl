# Pin Terragrunt version
terragrunt_version_constraint = "= 0.86.1"

locals {
  region          = "us-east-2"
  account_id      = "390259467653"
  account_name    = "Application-Workload-DEV-Account"
}

remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    region         = "us-east-2"
    dynamodb_table = "terraform-locks"  
    bucket         = "global-infra-state-us-east-2"
    key            = "dev/${path_relative_to_include()}/terraform.tfstate"
    
    # Cross-account access
    # role_arn = "arn:aws:iam::635566486216:role/TerraformStateExecutionRole"
    
    # If using profiles
    profile = "sifi_network"
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
  region  = "us-east-2"
  profile = "sifi_dev"
}
EOF
}

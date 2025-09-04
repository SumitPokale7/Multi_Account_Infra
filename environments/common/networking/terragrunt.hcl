# Pin Terragrunt version
terragrunt_version_constraint = "= 0.86.1"

# Remote state configuration (currently commented out)
# remote_state {
#   backend = "s3"
#   config = {
#     bucket         = "test-terraform-state"
#     key            = "${path_relative_to_include()}/terraform.tfstate"
#     region         = "us-east-1"
#     encrypt        = true
#     dynamodb_table = "test-lock-table"
#   }
# }

# Provider configuration
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "aws" {
  region  = "us-east-2"
  profile = "sifi_network"
}
EOF
}

# Assume role configuration (currently commented out)
# assume_role {
#   role_arn     = "arn:aws:iam::${local.account_id}:role/AWSAdministratorAccess"
#   session_name = "terragrunt-deploy"
# }

# Local variables
locals {
  account_id = "635566486216" # Networking account
}

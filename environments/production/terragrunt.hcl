# Pin Terragrunt version
terragrunt_version_constraint = "= 0.86.1"

# Remote state configuration (currently commented out)
# remote_state {
#   backend = "s3"
#   config = {
#     encrypt        = true
#     region         = "us-east-1"
#     dynamodb_table = "test-lock-table"
#     bucket         = "test-terraform-state"
#     key            = "${path_relative_to_include()}/terraform.tfstate"
#   }
# }

# Provider configuration
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "aws" {
  region  = "us-east-2"
  profile = "sifi_prod"
}
EOF
}

locals {
  region = "us-east-2"
  #   account_id      = "327903111409"
  #   account_name    = "Application-Workload-PROD-Account"
}

# Assume role configuration
# assume_role {
#   session_name = "terraform-deploy"
#   role_arn     = "arn:aws:iam::${local.account_id}:role/TerraformExecutionRole"
# }
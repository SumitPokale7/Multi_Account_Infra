# remote_state {
#   backend = "s3"
#   config = {
#     encrypt        = true
#     region         = "us-east-1"
#     dynamodb_table = "terraform-locks-prod"
#     bucket         = "my-terraform-state-prod"
#     key            = "${path_relative_to_include()}/terraform.tfstate"
#   }
# }

# inputs = {
#   environment = "production"
# }

# provider "aws" {
#   alias   = "target"
#   region  = var.region

#   assume_role {
#     role_arn = "arn:aws:iam::${var.account_id}:role/OrganizationAccountAccessRole"
#   }
# }
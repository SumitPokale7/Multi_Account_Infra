provider "aws" {
  alias  = "networking_account"
  region = "us-east-2"
  profile = "sifi_network"
  # assume_role {
  #   role_arn = "arn:aws:iam::635566486216:role/TerraformExecutionRole"
  # }
}

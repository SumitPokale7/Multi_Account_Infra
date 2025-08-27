resource "aws_organizations_organization" "org" {
  feature_set = "ALL"
}

resource "aws_organizations_account" "accounts" {
  iam_user_access_to_billing = "DENY"
  for_each                   = var.accounts
  name                       = each.value.name
  email                      = each.value.email
  role_name                  = "OrganizationAccountAccessRole"
  depends_on                 = [aws_organizations_organization.org]
}

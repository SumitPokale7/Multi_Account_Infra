output "account_ids" {
  value = { for k, acc in aws_organizations_account.accounts : k => acc.id }
}
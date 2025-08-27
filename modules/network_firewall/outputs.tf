output "firewall_arn" {
  value = aws_networkfirewall_firewall.this.arn
}

output "firewall_id" {
  value = aws_networkfirewall_firewall.this.id
}

output "firewall_policy_arn" {
  value = aws_networkfirewall_firewall_policy.this.arn
}

output "rule_group_arns" {
  value = { for k, rg in aws_networkfirewall_rule_group.this : k => rg.arn }
}

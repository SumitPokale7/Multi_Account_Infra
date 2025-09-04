output "web_acl_arn" {
  description = "ARN of the WAF Web ACL"
  value       = aws_wafv2_web_acl.this.arn
}

output "web_acl_id" {
  description = "ID of the WAF Web ACL"
  value       = aws_wafv2_web_acl.this.id
}

output "web_acl_capacity" {
  description = "Web ACL capacity units (WCUs) used by this web ACL"
  value       = aws_wafv2_web_acl.this.capacity
}

output "association_id" {
  description = "ID of the WAF association with ALB"
  value       = var.alb_arn != null ? aws_wafv2_web_acl_association.this[0].id : null
}

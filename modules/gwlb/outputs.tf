# modules/gwlb/outputs.tf

output "gwlb_id" {
  description = "ID of the Gateway Load Balancer"
  value       = aws_lb.gwlb.id
}

output "gwlb_arn" {
  description = "ARN of the Gateway Load Balancer"
  value       = aws_lb.gwlb.arn
}

output "gwlb_dns_name" {
  description = "DNS name of the Gateway Load Balancer"
  value       = aws_lb.gwlb.dns_name
}

output "gwlb_zone_id" {
  description = "Hosted zone ID of the Gateway Load Balancer"
  value       = aws_lb.gwlb.zone_id
}

output "target_group_arn" {
  description = "ARN of the Target Group"
  value       = aws_lb_target_group.gwlb.arn
}

output "target_group_id" {
  description = "ID of the Target Group"
  value       = aws_lb_target_group.gwlb.id
}

output "listener_arn" {
  description = "ARN of the Gateway Load Balancer Listener"
  value       = aws_lb_listener.gwlb.arn
}

output "listener_id" {
  description = "ID of the Gateway Load Balancer Listener"
  value       = aws_lb_listener.gwlb.id
}

output "endpoint_service_name" {
  description = "Service name of the VPC Endpoint Service (if created)"
  value       = var.create_endpoint_service ? aws_vpc_endpoint_service.gwlb[0].service_name : null
}

output "endpoint_service_arn" {
  description = "ARN of the VPC Endpoint Service (if created)"
  value       = var.create_endpoint_service ? aws_vpc_endpoint_service.gwlb[0].arn : null
}

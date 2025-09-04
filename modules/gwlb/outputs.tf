output "gwlb_arn" {
  description = "ARN of the Gateway Load Balancer"
  value       = aws_lb.gwlb.arn
}

output "gwlb_dns_name" {
  description = "DNS name of the Gateway Load Balancer"
  value       = aws_lb.gwlb.dns_name
}

output "gwlb_zone_id" {
  description = "Zone ID of the Gateway Load Balancer"
  value       = aws_lb.gwlb.zone_id
}

output "target_group_arn" {
  description = "ARN of the target group"
  value       = aws_lb_target_group.gwlb.arn
}

output "listener_arn" {
  description = "ARN of the listener"
  value       = aws_lb_listener.gwlb.arn
}

output "endpoint_service_name" {
  description = "Name of the VPC endpoint service"
  value       = var.create_endpoint_service ? aws_vpc_endpoint_service.gwlb[0].service_name : null
}

output "endpoint_service_id" {
  description = "ID of the VPC endpoint service"
  value       = var.create_endpoint_service ? aws_vpc_endpoint_service.gwlb[0].id : null
}

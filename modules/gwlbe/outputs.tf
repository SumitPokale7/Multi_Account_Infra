output "gwlbe_ids" {
  description = "List of Gateway Load Balancer Endpoint IDs"
  value       = aws_vpc_endpoint.gwlbe[*].id
}

output "gwlbe_dns_names" {
  description = "List of Gateway Load Balancer Endpoint DNS names"
  value       = [for endpoint in aws_vpc_endpoint.gwlbe : 
                 try(endpoint.dns_entry[0].dns_name, "")]
}

output "gwlbe_network_interface_ids" {
  description = "List of Gateway Load Balancer Endpoint network interface IDs"
  value       = aws_vpc_endpoint.gwlbe[*].network_interface_ids
}

output "gwlbe_subnet_ids" {
  description = "List of subnet IDs where GWLBEs are deployed"
  value       = var.subnet_ids
}

output "gwlbe_dns_entries" {
  description = "Complete DNS entry information for all GWLBEs"
  value       = aws_vpc_endpoint.gwlbe[*].dns_entry
}

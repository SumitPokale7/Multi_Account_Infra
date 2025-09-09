output "db_subnet_group_name" {
  description = "Name of the DB subnet group"
  value       = aws_db_subnet_group.this.name
}

output "db_subnet_group_id" {
  description = "ID of the DB subnet group"
  value       = aws_db_subnet_group.this.id
}

output "cluster_id" {
  description = "ID of the RDS cluster"
  value       = var.create_rds_cluster ? aws_rds_cluster.this[0].id : null
}

output "cluster_identifier" {
  description = "Cluster identifier"
  value       = var.create_rds_cluster ? aws_rds_cluster.this[0].cluster_identifier : null
}

output "cluster_endpoint" {
  description = "RDS cluster endpoint"
  value       = var.create_rds_cluster ? aws_rds_cluster.this[0].endpoint : null
}

output "cluster_reader_endpoint" {
  description = "RDS cluster reader endpoint"
  value       = var.create_rds_cluster ? aws_rds_cluster.this[0].reader_endpoint : null
}

output "cluster_port" {
  description = "RDS cluster port"
  value       = var.create_rds_cluster ? aws_rds_cluster.this[0].port : null
}

output "cluster_master_username" {
  description = "RDS cluster master username"
  value       = var.create_rds_cluster ? aws_rds_cluster.this[0].master_username : null
}

output "cluster_arn" {
  description = "RDS cluster ARN"
  value       = var.create_rds_cluster ? aws_rds_cluster.this[0].arn : null
}

output "cluster_engine" {
  description = "RDS cluster engine"
  value       = var.create_rds_cluster ? aws_rds_cluster.this[0].engine : null
}

output "cluster_engine_version" {
  description = "RDS cluster engine version"
  value       = var.create_rds_cluster ? aws_rds_cluster.this[0].engine_version_actual : null
}

output "instance_ids" {
  description = "List of RDS instance IDs"
  value       = var.create_rds_cluster ? aws_rds_cluster_instance.this[*].id : []
}

output "instance_endpoints" {
  description = "List of RDS instance endpoints"
  value       = var.create_rds_cluster ? aws_rds_cluster_instance.this[*].endpoint : []
}

output "instance_arns" {
  description = "List of RDS instance ARNs"
  value       = var.create_rds_cluster ? aws_rds_cluster_instance.this[*].arn : []
}

output "cluster_id" {
  value = aws_rds_cluster.this.id
}

output "cluster_endpoint" {
  value = aws_rds_cluster.this.endpoint
}

output "reader_endpoint" {
  value = aws_rds_cluster.this.reader_endpoint
}

output "instance_endpoints" {
  value = [for i in aws_rds_cluster_instance.this : i.endpoint]
}

output "instance_ids" {
  value = [for i in aws_instance.this : i.id]
}

output "instance_types" {
  value = [for i in aws_instance.this : i.instance_type]
}

output "public_ips" {
  value = aws_instance.this[*].public_ip
}

output "private_ips" {
  value = aws_instance.this[*].private_ip
}

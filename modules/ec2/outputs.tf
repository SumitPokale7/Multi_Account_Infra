output "key_name" {
  description = "The name of the EC2 key pair"
  value       = aws_key_pair.this.key_name
}

output "private_key_pem" {
  description = "The private key in PEM format"
  value       = tls_private_key.this.private_key_pem
  sensitive   = true
}

output "public_key" {
  description = "The public key in OpenSSH format"
  value       = tls_private_key.this.public_key_openssh
}

output "instance_ids" {
  description = "Map of instance names to their IDs"
  value = {
    for k, instance in aws_instance.this : k => instance.id
  }
}

# Output private IPs as a map
output "private_ips" {
  description = "Map of instance names to their private IPs"
  value = {
    for k, instance in aws_instance.this : k => instance.private_ip
  }
}

output "public_ips" {
  description = "Map of instance names to their public IPs"
  value = {
    for k, instance in aws_instance.this : k => instance.public_ip
  }
}

output "instance_ids_list" {
  description = "List of all instance IDs"
  value = values(aws_instance.this)[*].id
}

output "private_ips_list" {
  description = "List of all private IPs"
  value = values(aws_instance.this)[*].private_ip
}

output "public_ips_list" {
  description = "List of all public IPs"
  value = values(aws_instance.this)[*].public_ip
}

output "instances" {
  description = "Complete instance information"
  value = {
    for k, instance in aws_instance.this : var.instances[k].name => {
      id            = instance.id
      private_ip    = instance.private_ip
      public_ip     = instance.public_ip
      subnet_id     = instance.subnet_id
      instance_type = instance.instance_type
    }
  }
}

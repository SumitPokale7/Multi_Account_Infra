terraform {
  required_version = ">= 1.9.7, < 1.10.0"
}

resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "this" {
  key_name   = "${var.project}-key"
  public_key = tls_private_key.this.public_key_openssh

  tags = var.tags
}

# Store private key in AWS Systems Manager
resource "aws_ssm_parameter" "private_key" {
  name  = "/${var.project}/ec2/private-key"
  type  = "SecureString"
  value = tls_private_key.this.private_key_pem

  tags = var.tags
}


resource "aws_instance" "this" {
  for_each = { for idx, inst in var.instances : idx => inst }

  ami                    = var.ami
  key_name               = aws_key_pair.this.key_name
  subnet_id              = each.value.subnet_id
  vpc_security_group_ids = each.value.security_group_ids
  instance_type          = each.value.instance_type

  tags = merge(
    var.tags,
    { 
      Name = each.value.name,
      Tier = split("-", each.value.name)[1]
    }
  )
}
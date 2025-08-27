resource "aws_security_group" "this" {
  for_each    = var.security_groups

  name        = each.key
  vpc_id      = var.vpc_id
  description = "SG for ${each.key}"

  dynamic "ingress" {
    for_each = each.value.ingress
    content {
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      from_port   = ingress.value.from_port
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = each.value.egress
    content {
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      from_port   = egress.value.from_port
      cidr_blocks = egress.value.cidr_blocks
    }
  }
}



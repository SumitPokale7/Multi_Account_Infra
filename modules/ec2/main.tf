resource "aws_instance" "this" {
  for_each = { for idx, inst in var.instances : idx => inst }

  ami                    = var.ami
  key_name               = var.key_name
  subnet_id              = each.value.subnet_id
  vpc_security_group_ids = var.security_group_ids
  instance_type          = each.value.instance_type

  tags = merge(
    var.tags,
    { Name = each.value.name }
  )
}

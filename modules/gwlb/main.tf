resource "aws_vpc_endpoint" "this" {
  vpc_id            = var.vpc_id
  service_name      = var.service_name
  vpc_endpoint_type = "GatewayLoadBalancer"
  subnet_ids        = var.subnet_ids

  tags = merge(var.tags, { Name = "${var.name}-gwlbe" })
}

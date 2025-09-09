terraform {
  required_version = ">= 1.9.7, < 1.10.0"
}

# Gateway Load Balancer Endpoint
resource "aws_vpc_endpoint" "gwlbe" {
  count = length(var.subnet_ids)

  vpc_id              = var.vpc_id
  service_name        = var.service_name
  vpc_endpoint_type   = "GatewayLoadBalancer"
  subnet_ids          = [var.subnet_ids[count.index]]
  
  tags = merge(var.tags, {
    Name = "${var.project_name}-gwlbe-${count.index + 1}"
    Type = "GatewayLoadBalancerEndpoint"
  })
}

# Route Table Associations for GWLBE
resource "aws_route_table_association" "gwlbe" {
  count = var.associate_route_tables ? length(var.route_table_ids) : 0

  subnet_id      = var.subnet_ids[count.index]
  route_table_id = var.route_table_ids[count.index]
}

# Routes pointing to GWLBE
resource "aws_route" "to_gwlbe" {
  count = var.create_routes ? length(var.route_configs) : 0

  route_table_id         = var.route_configs[count.index].route_table_id
  destination_cidr_block = var.route_configs[count.index].destination_cidr
  vpc_endpoint_id        = aws_vpc_endpoint.gwlbe[var.route_configs[count.index].gwlbe_index].id
}

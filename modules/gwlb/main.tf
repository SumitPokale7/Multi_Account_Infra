terraform {
  required_version = ">= 1.9.7, < 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.12.0"
    }
  }
}

# Gateway Load Balancer
resource "aws_lb" "gwlb" {
  name               = "${var.project_name}-gwlb"
  load_balancer_type = "gateway"
  
  subnet_mapping {
    subnet_id = var.subnet_ids[0]
  }

  dynamic "subnet_mapping" {
    for_each = length(var.subnet_ids) > 1 ? slice(var.subnet_ids, 1, length(var.subnet_ids)) : []
    content {
      subnet_id = subnet_mapping.value
    }
  }

  enable_deletion_protection = var.enable_deletion_protection

  tags = merge(var.tags, {
    Name = "${var.project_name}-gwlb"
    Type = "GatewayLoadBalancer"
  })
}

# Target Group for GWLB
resource "aws_lb_target_group" "gwlb" {
  name     = "${var.project_name}-gwlb-tg"
  port     = var.target_group_port
  protocol = "GENEVE"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = var.health_check_enabled
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
    interval            = var.health_check_interval
    path                = var.health_check_protocol == "HTTP" || var.health_check_protocol == "HTTPS" ? var.health_check_path : null
    port                = var.health_check_port
    protocol            = var.health_check_protocol
    timeout             = var.health_check_timeout
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-gwlb-tg"
    Type = "GatewayLoadBalancerTargetGroup"
  })
}

# Listener for GWLB
resource "aws_lb_listener" "gwlb" {
  load_balancer_arn = aws_lb.gwlb.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.gwlb.arn
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-gwlb-listener"
  })
}

# Target Group Attachments (if target IDs are provided)
resource "aws_lb_target_group_attachment" "gwlb" {
  count = length(var.target_ids)

  target_group_arn = aws_lb_target_group.gwlb.arn
  target_id        = var.target_ids[count.index]
  port             = var.target_group_port
}

# VPC Endpoint Service
resource "aws_vpc_endpoint_service" "gwlb" {
  count = var.create_endpoint_service ? 1 : 0

  acceptance_required        = var.endpoint_service_acceptance_required
  gateway_load_balancer_arns = [aws_lb.gwlb.arn]
  
  tags = merge(var.tags, {
    Name = "${var.project_name}-gwlb-endpoint-service"
    Type = "VPCEndpointService"
  })
}

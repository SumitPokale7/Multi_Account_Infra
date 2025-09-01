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
    matcher             = var.health_check_matcher
    path                = var.health_check_path
    port                = var.health_check_port
    protocol            = var.health_check_protocol
    timeout             = var.health_check_timeout
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-gwlb-tg"
    Type = "GatewayLoadBalancerTargetGroup"
  })
}

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

resource "aws_lb_target_group_attachment" "gwlb" {
  count = length(var.target_ids)

  target_group_arn = aws_lb_target_group.gwlb.arn
  target_id        = var.target_ids[count.index]
  port             = var.target_group_port
}

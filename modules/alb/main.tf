terraform {
  required_version = ">= 1.9.7, < 1.10.0"
}

resource "aws_lb" "this" {
  name               = var.name
  internal           = var.internal
  load_balancer_type = "application"
  subnets            = var.subnet_ids
  security_groups    = var.security_group_ids
  tags               = merge(var.tags, { Name = var.name })
}

resource "aws_lb_target_group" "this" {
  count    = var.create_target_group ? 1 : 0

  vpc_id   = var.vpc_id
  name     = "${var.name}-tg"
  port     = var.target_port != null ? var.target_port : 80
  protocol = var.target_protocol != null ? var.target_protocol : "HTTP"
  tags     = merge(var.tags, { Name = "${var.name}-tg" })
}

resource "aws_lb_listener" "with_tg" {
  count             = var.create_target_group ? 1 : 0

  load_balancer_arn = aws_lb.this.arn
  port              = var.listener_port
  protocol          = var.listener_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[0].arn
  }
}

resource "aws_lb_listener" "without_tg" {
  count             = var.create_target_group ? 0 : 1

  load_balancer_arn = aws_lb.this.arn
  port              = var.listener_port
  protocol          = var.listener_protocol

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "No target group configured"
      status_code  = "404"
    }
  }
}

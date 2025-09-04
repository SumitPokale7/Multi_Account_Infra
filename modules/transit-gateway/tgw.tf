terraform {
  required_version = ">= 1.5.7, < 1.6.0"
}

# Transit Gateway
resource "aws_ec2_transit_gateway" "main" {
  description = var.description
  
  amazon_side_asn                 = var.amazon_side_asn
  auto_accept_shared_attachments  = var.auto_accept_shared_attachments
  default_route_table_association = var.default_route_table_association
  default_route_table_propagation = var.default_route_table_propagation
  dns_support                     = var.dns_support
  vpn_ecmp_support                = var.vpn_ecmp_support
  multicast_support               = var.multicast_support
  
  tags = merge(var.common_tags, {
    Name = var.tgw_name
  })
}

# RAM Resource Share for cross-account sharing
resource "aws_ram_resource_share" "tgw" {
  count = var.enable_cross_account_sharing ? 1 : 0
  
  name                      = var.ram_share_name
  allow_external_principals = var.allow_external_principals
  
  tags = merge(var.common_tags, {
    Name = var.ram_share_name
  })
}

# Associate TGW with RAM Resource Share
resource "aws_ram_resource_association" "tgw" {
  count = var.enable_cross_account_sharing ? 1 : 0
  
  resource_arn       = aws_ec2_transit_gateway.main.arn
  resource_share_arn = aws_ram_resource_share.tgw[0].arn
}

# Invite external accounts to the resource share
resource "aws_ram_principal_association" "accounts" {
  count = var.enable_cross_account_sharing ? length(var.shared_account_ids) : 0
  
  principal          = var.shared_account_ids[count.index]
  resource_share_arn = aws_ram_resource_share.tgw[0].arn
}

# CloudWatch Log Group for Flow Logs
resource "aws_cloudwatch_log_group" "tgw_flow_logs" {
  count = var.enable_flow_logs ? 1 : 0
  
  name              = "/aws/transitgateway/${var.tgw_name}/flowlogs"
  retention_in_days = var.flow_logs_retention_days
  
  tags = merge(var.common_tags, {
    Name = "${var.tgw_name}-flow-logs"
  })
}

# IAM Role for Flow Logs
resource "aws_iam_role" "flow_logs" {
  count = var.enable_flow_logs ? 1 : 0
  
  name = "${var.tgw_name}-flow-logs-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
      }
    ]
  })
  
  tags = var.common_tags
}

# IAM Policy for Flow Logs
resource "aws_iam_role_policy" "flow_logs" {
  count = var.enable_flow_logs ? 1 : 0
  
  name = "${var.tgw_name}-flow-logs-policy"
  role = aws_iam_role.flow_logs[0].id
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Resource = "*"
      }
    ]
  })
}

# TGW Flow Logs
resource "aws_flow_log" "tgw" {
  count = var.enable_flow_logs ? 1 : 0

  transit_gateway_id   = aws_ec2_transit_gateway.main.id
  iam_role_arn         = aws_iam_role.flow_logs[0].arn
  log_destination      = aws_cloudwatch_log_group.tgw_flow_logs[0].arn
  log_destination_type = "cloud-watch-logs"
  traffic_type         = "ALL"
  max_aggregation_interval = 60

  tags = merge(var.common_tags, {
    Name = "${var.tgw_name}-flow-logs"
  })
}

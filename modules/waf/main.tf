terraform {
  required_version = ">= 1.9.7, < 1.10.0"
}

locals {
  is_allow = var.default_action == "allow"
}

# main.tf
resource "aws_wafv2_web_acl" "this" {
  name        = "${var.name}-waf"
  description = "WAF for ${var.name}"
  scope       = var.scope

  default_action {
    dynamic "allow" {
      for_each = local.is_allow ? [1] : []
      content {}
    }
    
    dynamic "block" {
      for_each = local.is_allow ? [] : [1]
      content {}
    }
  }

  # Managed Rules
  dynamic "rule" {
    for_each = var.managed_rules
    content {
      name     = rule.value.name
      priority = rule.value.priority

      override_action {
        dynamic "none" {
          for_each = rule.value.override_action == "none" ? [1] : []
          content {}
        }
        
        dynamic "count" {
          for_each = rule.value.override_action == "count" ? [1] : []
          content {}
        }
      }

      statement {
        managed_rule_group_statement {
          name        = rule.value.rule_name
          vendor_name = rule.value.vendor_name

          dynamic "rule_action_override" {
            for_each = length(rule.value.excluded_rules) > 0 ? rule.value.excluded_rules : []
            content {
              action_to_use {
                count {}
              }
              name = rule_action_override.value
            }
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = rule.value.name
        sampled_requests_enabled   = true
      }
    }
  }

  # Rate Limit Rules
  dynamic "rule" {
    for_each = var.rate_limit_rules
    content {
      name     = rule.value.name
      priority = rule.value.priority

      action {
        dynamic "allow" {
          for_each = rule.value.action == "allow" ? [1] : []
          content {}
        }
        
        dynamic "block" {
          for_each = rule.value.action == "block" ? [1] : []
          content {}
        }
        
        dynamic "count" {
          for_each = rule.value.action == "count" ? [1] : []
          content {}
        }
      }

      statement {
        rate_based_statement {
          limit              = rule.value.limit
          aggregate_key_type = rule.value.scope
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = rule.value.name
        sampled_requests_enabled   = true
      }
    }
  }

  # Custom Rules
  dynamic "rule" {
    for_each = var.custom_rules
    content {
      name     = rule.value.name
      priority = rule.value.priority

      action {
        dynamic "allow" {
          for_each = rule.value.action == "allow" ? [1] : []
          content {}
        }
        
        dynamic "block" {
          for_each = rule.value.action == "block" ? [1] : []
          content {}
        }
        
        dynamic "count" {
          for_each = rule.value.action == "count" ? [1] : []
          content {}
        }
      }

      statement {
        # This would need to be expanded based on your specific custom rule requirements
        # For now, assuming the statement is passed as a complex object
        dynamic "geo_match_statement" {
          for_each = lookup(rule.value.statement, "geo_match_statement", null) != null ? [rule.value.statement.geo_match_statement] : []
          content {
            country_codes = geo_match_statement.value.country_codes
          }
        }

        dynamic "ip_set_reference_statement" {
          for_each = lookup(rule.value.statement, "ip_set_reference_statement", null) != null ? [rule.value.statement.ip_set_reference_statement] : []
          content {
            arn = ip_set_reference_statement.value.arn
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = rule.value.name
        sampled_requests_enabled   = true
      }
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.name}-waf"
    sampled_requests_enabled   = true
  }

  tags = var.tags
}

# ALB Association
resource "aws_wafv2_web_acl_association" "this" {
  count = var.alb_arn != null ? 1 : 0

  resource_arn = var.alb_arn
  web_acl_arn  = aws_wafv2_web_acl.this.arn
}

# WAF Logging Configuration
resource "aws_wafv2_web_acl_logging_configuration" "this" {
  count = var.logging_enabled && length(var.log_destination_configs) > 0 ? 1 : 0

  resource_arn            = aws_wafv2_web_acl.this.arn
  log_destination_configs = var.log_destination_configs

  redacted_fields {
    single_header {
      name = "authorization"
    }
  }

  redacted_fields {
    single_header {
      name = "cookie"
    }
  }
}

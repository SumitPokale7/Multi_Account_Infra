include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../../modules/waf"
}

dependency "alb" {
  config_path = "../alb"

  mock_outputs = {
    alb_arn = "mock_alb_arn"
  }
}

inputs = {
  name               = "dmz"
  waf_default_action = "allow"
  
  waf_common_rules = [
    {
      name            = "AWSManagedRulesCommonRuleSet"
      priority        = 1
      vendor_name     = "AWS"
      rule_name       = "AWSManagedRulesCommonRuleSet"
      override_action = "none"
      excluded_rules  = []  # Optional: rules to exclude from this managed rule group
    },
    {
      name            = "AWSManagedRulesAmazonIpReputationList"
      priority        = 2
      vendor_name     = "AWS"
      rule_name       = "AWSManagedRulesAmazonIpReputationList"
      override_action = "none"
      excluded_rules  = []
    },
    {
      name            = "AWSManagedRulesKnownBadInputsRuleSet"
      priority        = 3
      vendor_name     = "AWS"
      rule_name       = "AWSManagedRulesKnownBadInputsRuleSet"
      override_action = "none"
      excluded_rules  = []
    },
    {
      name            = "AWSManagedRulesSQLiRuleSet"
      priority        = 4
      vendor_name     = "AWS"
      rule_name       = "AWSManagedRulesSQLiRuleSet"
      override_action = "none"
      excluded_rules  = []
    }
  ]

  # Rate limiting rules (optional)
  waf_rate_limit_rules = [
    {
      name     = "RateLimitRule"
      priority = 100
      limit    = 2000
      scope    = "IP"  # IP or FORWARDED_IP
      action   = "block"
      excluded_rules = []
    }
  ]

  # Custom rules (optional)
  waf_custom_rules = []

  # WAF logging configuration
  waf_logging_enabled = false
  waf_log_destination_configs = []  # S3 bucket ARNs, CW log group ARNs, or Kinesis Data Firehose delivery stream ARNs
}
variable "name" {
  description = "Name prefix for WAF resources"
  type        = string
}

variable "scope" {
  description = "Scope of the WAF (REGIONAL or CLOUDFRONT)"
  type        = string
  default     = "REGIONAL"
  
  validation {
    condition     = contains(["REGIONAL", "CLOUDFRONT"], var.scope)
    error_message = "Scope must be either REGIONAL or CLOUDFRONT."
  }
}

variable "default_action" {
  description = "Default action for the WAF (allow or block)"
  type        = string
  default     = "allow"
  
  validation {
    condition     = contains(["allow", "block"], var.default_action)
    error_message = "Default action must be either allow or block."
  }
}

variable "managed_rules" {
  description = "List of AWS managed rule groups"
  type = list(object({
    name            = string
    priority        = number
    vendor_name     = string
    rule_name       = string
    override_action = string
    excluded_rules  = list(string)
  }))
  default = []
}

variable "rate_limit_rules" {
  description = "List of rate limiting rules"
  type = list(object({
    name     = string
    priority = number
    limit    = number
    scope    = string  # IP or FORWARDED_IP
    action   = string  # block or count
    excluded_rules = list(string)
  }))
  default = []
}

variable "custom_rules" {
  description = "List of custom WAF rules"
  type = list(object({
    name      = string
    priority  = number
    action    = string  # allow, block, or count
    statement = any     # Complex statement structure
  }))
  default = []
}

variable "alb_arn" {
  description = "ARN of the ALB to associate with the WAF"
  type        = string
  default     = null
}

variable "logging_enabled" {
  description = "Enable WAF logging"
  type        = bool
  default     = false
}

variable "log_destination_configs" {
  description = "List of log destination ARNs"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to WAF resources"
  type        = map(string)
  default     = {}
}

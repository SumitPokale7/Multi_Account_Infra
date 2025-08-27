variable "name" {
  description = "Name of the firewall"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the firewall will be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs where the firewall will be deployed"
  type        = list(string)
}

variable "rule_groups" {
  description = <<EOT
Map of rule groups to create.
Example:
{
  stateless-allow-http = {
    capacity   = 100
    type       = "STATELESS"
    priority   = 10
    rule_group = {
      rules_source = {
        stateless_rules_and_custom_actions = {
          stateless_rules = [
            {
              rule_definition = {
                actions = ["aws:pass"]
                match_attributes = {
                  protocols   = [6]
                  source      = [{ address_definition = "0.0.0.0/0" }]
                  destination = [{ address_definition = "0.0.0.0/0" }]
                  source_ports      = [{ from_port = 0, to_port = 65535 }]
                  destination_ports = [{ from_port = 80, to_port = 80 }]
                }
              }
              priority = 1
            }
          ]
        }
      }
    }
  }
}
EOT
  type = map(object({
    capacity   = number
    type       = string
    priority   = optional(number)
    rule_group = any
  }))
  default = {}
}

variable "stateless_default_actions" {
  description = "Default stateless actions (e.g. drop or forward)"
  type        = list(string)
  default     = ["aws:forward_to_sfe"]
}

variable "stateless_fragment_default_actions" {
  description = "Default actions for fragmented packets"
  type        = list(string)
  default     = ["aws:forward_to_sfe"]
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}

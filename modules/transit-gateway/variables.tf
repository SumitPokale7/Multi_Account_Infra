variable "tgw_name" {
  description = "Name of the Transit Gateway"
  type        = string
}

variable "description" {
  description = "Description of the Transit Gateway"
  type        = string
  default     = "Central Transit Gateway for multi-account connectivity"
}

variable "amazon_side_asn" {
  description = "Private Autonomous System Number (ASN) for the Amazon side of a BGP session"
  type        = number
  default     = 64512
}

variable "auto_accept_shared_attachments" {
  description = "Whether resource attachment requests are automatically accepted"
  type        = string
  default     = "enable"
}

variable "default_route_table_association" {
  description = "Whether resource attachments are automatically associated with the default association route table"
  type        = string
  default     = "disable"
}

variable "default_route_table_propagation" {
  description = "Whether resource attachments automatically propagate routes to the default propagation route table"
  type        = string
  default     = "disable"
}

variable "dns_support" {
  description = "Whether DNS resolution is supported"
  type        = string
  default     = "enable"
}

variable "vpn_ecmp_support" {
  description = "Whether Equal Cost Multipath Protocol support is enabled"
  type        = string
  default     = "enable"
}

variable "multicast_support" {
  description = "Whether multicast is enabled on the transit gateway"
  type        = string
  default     = "disable"
}

variable "common_tags" {
  description = "Common tags to be applied to all resources"
  type        = map(string)
  default     = {}
}

# Route Table Configuration
variable "create_default_route_table" {
  description = "Whether to create a default route table"
  type        = bool
  default     = true
}

variable "custom_route_tables" {
  description = "Map of custom route tables to create"
  type        = map(object({
    description = optional(string)
  }))
  default = {}
}

# Cross-Account Sharing Configuration
variable "enable_cross_account_sharing" {
  description = "Whether to enable cross-account sharing via RAM"
  type        = bool
  default     = true
}

variable "ram_share_name" {
  description = "Name of the RAM resource share"
  type        = string
  default     = "transit-gateway-share"
}

variable "allow_external_principals" {
  description = "Whether to allow external principals (outside organization) to be associated with resource share"
  type        = bool
  default     = false
}

variable "shared_account_ids" {
  description = "List of AWS account IDs to share the Transit Gateway with"
  type        = list(string)
  default     = []
}

# SSM Parameter Configuration
variable "store_in_ssm" {
  description = "Whether to store TGW ID in SSM Parameter Store"
  type        = bool
  default     = true
}

variable "ssm_parameter_name" {
  description = "Name of the SSM parameter to store TGW ID"
  type        = string
  default     = "/networking/transit-gateway/id"
}

# Flow Logs Configuration
variable "enable_flow_logs" {
  description = "Whether to enable VPC Flow Logs for the Transit Gateway"
  type        = bool
  default     = false
}

variable "flow_logs_retention_days" {
  description = "Number of days to retain flow logs"
  type        = number
  default     = 14
}

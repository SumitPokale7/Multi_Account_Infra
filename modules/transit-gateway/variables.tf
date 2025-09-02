variable "tgw_name" {
  description = "Name for the Transit Gateway"
  type        = string
}

variable "description" {
  description = "Description for the Transit Gateway"
  type        = string
  default     = "Transit Gateway for multi-VPC connectivity"
}

variable "amazon_side_asn" {
  description = "Private Autonomous System Number (ASN) for the Amazon side of a BGP session"
  type        = number
  default     = 64512
}

variable "auto_accept_shared_attachments" {
  description = "Whether resource attachment requests are automatically accepted"
  type        = string
  default     = "disable"
}

variable "default_route_table_association" {
  description = "Whether resource attachments are automatically associated with the default association route table"
  type        = string
  default     = "enable"
}

variable "default_route_table_propagation" {
  description = "Whether resource attachments automatically propagate routes to the default propagation route table"
  type        = string
  default     = "enable"
}

variable "dns_support" {
  description = "Whether DNS support is enabled"
  type        = string
  default     = "enable"
}

variable "vpn_ecmp_support" {
  description = "Whether Equal Cost Multipath Protocol support is enabled"
  type        = string
  default     = "enable"
}

variable "multicast_support" {
  description = "Whether multicast support is enabled"
  type        = string
  default     = "disable"
}

# Cross-account sharing
variable "enable_cross_account_sharing" {
  description = "Enable cross-account sharing via RAM"
  type        = bool
  default     = false
}

variable "ram_share_name" {
  description = "Name for the RAM resource share"
  type        = string
  default     = ""
}

variable "allow_external_principals" {
  description = "Allow sharing with external principals"
  type        = bool
  default     = false
}

variable "shared_account_ids" {
  description = "List of AWS account IDs to share the TGW with"
  type        = list(string)
  default     = []
}

# Flow logs
variable "enable_flow_logs" {
  description = "Enable VPC Flow Logs for the Transit Gateway"
  type        = bool
  default     = false
}

variable "flow_logs_retention_days" {
  description = "Number of days to retain flow logs"
  type        = number
  default     = 14
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}
# VPC Configuration
variable "vpc_name" {
  description = "Name for the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Enable DNS support in the VPC"
  type        = bool
  default     = true
}

# Subnet Configuration
variable "private_subnets" {
  description = "List of private subnet configurations"
  type = list(object({
    cidr    = string
    az      = string
    purpose = string
  }))
  default = []
}

variable "public_subnets" {
  description = "List of public subnet configurations"
  type = list(object({
    cidr = string
    az   = string
  }))
  default = []
}

# Gateway Configuration
variable "create_igw" {
  description = "Whether to create an Internet Gateway"
  type        = bool
  default     = false
}

variable "create_nat_gateway" {
  description = "Whether to create NAT Gateways"
  type        = bool
  default     = false
}

# Transit Gateway Configuration
variable "attach_to_tgw" {
  description = "Whether to attach VPC to Transit Gateway"
  type        = bool
  default     = false
}

variable "transit_gateway_id" {
  description = "Transit Gateway ID for attachment"
  type        = string
  default     = null
}

variable "tgw_subnet_ids" {
  description = "Specific subnet IDs for TGW attachment (if null, uses all private subnets)"
  type        = list(string)
  default     = null
}

variable "tgw_routes" {
  type    = map(string)
  default = {}
}

# Common Configuration
variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {
    ManagedBy = "terraform"
  }
}

variable "account_id" {
  description = "AWS Account ID"
  type        = string
  default     = null
}

variable "assume_role_arn" {
  description = "IAM role ARN to assume"
  type        = string
  default     = null
}

variable "transit_gateway_id" {
  description = "ID of the Transit Gateway"
  type        = string
}

# Route Table Creation Flags
variable "create_security_route_table" {
  description = "Create security route table"
  type        = bool
  default     = true
}

variable "create_production_route_table" {
  description = "Create production route table"
  type        = bool
  default     = true
}

variable "create_development_route_table" {
  description = "Create development route table"
  type        = bool
  default     = true
}

# Routing Behavior
variable "route_production_through_security" {
  description = "Route production traffic through security inspection"
  type        = bool
  default     = true
}

variable "route_development_through_security" {
  description = "Route development traffic through security inspection"
  type        = bool
  default     = true
}

variable "route_internet_through_security" {
  description = "Route internet traffic through security inspection"
  type        = bool
  default     = true
}

variable "isolate_environments" {
  description = "Prevent direct communication between production and development"
  type        = bool
  default     = true
}

# CIDR Blocks
variable "production_cidrs" {
  description = "CIDR blocks for production environments"
  type        = list(string)
  default     = []
}

variable "development_cidrs" {
  description = "CIDR blocks for development environments"
  type        = list(string)
  default     = []
}

variable "security_cidrs" {
  description = "CIDR blocks for security environments"
  type        = list(string)
  default     = []
}

variable "internet_cidr" {
  description = "CIDR block representing internet traffic"
  type        = string
  default     = "0.0.0.0/0"
}

# Naming
variable "route_table_name_prefix" {
  description = "Prefix for route table names"
  type        = string
  default     = "tgw"
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}
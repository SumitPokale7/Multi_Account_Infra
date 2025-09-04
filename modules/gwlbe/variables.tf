# modules/gwlbe/variables.tf

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the Gateway Load Balancer Endpoints will be created"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the Gateway Load Balancer Endpoints"
  type        = list(string)
}

variable "service_name" {
  description = "VPC endpoint service name (from GWLB module output)"
  type        = string
}

variable "associate_route_tables" {
  description = "Whether to associate route tables with subnets"
  type        = bool
  default     = false
}

variable "route_table_ids" {
  description = "List of route table IDs to associate with subnets"
  type        = list(string)
  default     = []
}

variable "create_routes" {
  description = "Whether to create routes pointing to GWLBE"
  type        = bool
  default     = false
}

variable "route_configs" {
  description = "List of route configurations"
  type = list(object({
    route_table_id   = string
    destination_cidr = string
    gwlbe_index      = number
  }))
  default = []
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

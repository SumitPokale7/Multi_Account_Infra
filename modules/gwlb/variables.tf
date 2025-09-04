# modules/gwlb/variables.tf

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the Gateway Load Balancer"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID where the Gateway Load Balancer will be created"
  type        = string
}

variable "target_group_port" {
  description = "Port for the target group"
  type        = number
  default     = 6081
}

variable "target_ids" {
  description = "List of target IDs to attach to the target group"
  type        = list(string)
  default     = []
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection for the load balancer"
  type        = bool
  default     = false
}

variable "health_check_enabled" {
  description = "Enable health checks"
  type        = bool
  default     = true
}

variable "healthy_threshold" {
  description = "Number of consecutive health checks successes required"
  type        = number
  default     = 2
}

variable "unhealthy_threshold" {
  description = "Number of consecutive health check failures required"
  type        = number
  default     = 2
}

variable "health_check_interval" {
  description = "Interval between health checks"
  type        = number
  default     = 30
}

variable "health_check_path" {
  description = "Health check path"
  type        = string
  default     = "/"
}

variable "health_check_port" {
  description = "Port for health checks"
  type        = string
  default     = "traffic-port"
}

variable "health_check_protocol" {
  description = "Protocol for health checks"
  type        = string
  default     = "HTTP"
}

variable "health_check_timeout" {
  description = "Health check timeout"
  type        = number
  default     = 5
}

variable "create_endpoint_service" {
  description = "Whether to create VPC endpoint service"
  type        = bool
  default     = true
}

variable "endpoint_service_acceptance_required" {
  description = "Whether acceptance is required for the VPC endpoint service"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

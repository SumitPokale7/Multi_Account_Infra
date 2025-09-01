# modules/gwlb/variables.tf

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the GWLB will be created"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs where the GWLB will be deployed"
  type        = list(string)
}

variable "target_ids" {
  description = "List of target IDs to attach to the target group"
  type        = list(string)
  default     = []
}

variable "target_group_port" {
  description = "Port for the target group"
  type        = number
  default     = 6081
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection for the load balancer"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

# Health Check Variables
variable "health_check_enabled" {
  description = "Enable health checks"
  type        = bool
  default     = true
}

variable "healthy_threshold" {
  description = "Number of consecutive health checks successes required before considering an unhealthy target healthy"
  type        = number
  default     = 3
}

variable "unhealthy_threshold" {
  description = "Number of consecutive health check failures required before considering a target unhealthy"
  type        = number
  default     = 3
}

variable "health_check_interval" {
  description = "Approximate amount of time between health checks"
  type        = number
  default     = 10
}

variable "health_check_matcher" {
  description = "Response codes to use when checking for a healthy responses from a target"
  type        = string
  default     = "200-399"
}

variable "health_check_path" {
  description = "Destination for the health check request"
  type        = string
  default     = "/"
}

variable "health_check_port" {
  description = "Port to use to connect with the target for health checking"
  type        = string
  default     = "traffic-port"
}

variable "health_check_protocol" {
  description = "Protocol to use to connect with the target for health checking"
  type        = string
  default     = "HTTP"
}

variable "health_check_timeout" {
  description = "Amount of time during which no response means a failed health check"
  type        = number
  default     = 6
}

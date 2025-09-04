variable "create_ssm_endpoint_service" {
  description = "Whether to create SSM VPC endpoints"
  type        = bool
  default     = true
}

variable "region" {
  description = "AWS region"
  type        = string
  # default     = "us-east-2"
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the SSM Endpoints"
  type        = list(string)
}

variable "security_group_ids" { 
  type = list(string) 
}

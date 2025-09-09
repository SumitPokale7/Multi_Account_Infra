variable "project" {
  description = "Project name"
  type        = string
}

variable "store_private_key" {
  description = "Whether to store private key in SSM Parameter Store"
  type        = bool
  default     = true
}

variable "ami" {
  description = "AMI ID to use for instances"
  type        = string
}

variable "key_name" {
  description = "EC2 Key Pair name"
  type        = string
}

variable "instances" {
  description = "List of instance configurations"
  type = list(object({
    name                = string
    instance_type       = string
    subnet_id           = string
    security_group_ids  = list(string)
  }))
}

variable "tags" {
  description = "Default tags to apply to all resources"
  type        = map(string)
  default     = {}
}

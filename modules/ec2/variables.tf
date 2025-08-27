variable "ami" {
  description = "AMI ID for the instance"
  type        = string
}

variable "instances" {
  description = "List of EC2 instances to create with type and name"
  type = list(object({
    name          = string
    instance_type = string
    subnet_id     = string
  }))
}

variable "instance_count" {
  description = "Number of EC2 instances to create"
  type        = number
  default     = 1
}

variable "security_group_ids" {
  description = "List of security group IDs to associate"
  type        = list(string)
}

variable "key_name" {
  description = "Key pair name for SSH access"
  type        = string
  default     = null
}

variable "name_prefix" {
  description = "Prefix for instance names"
  type        = string
  default     = "ec2"
}

variable "tags" {
  description = "Additional tags to apply"
  type        = map(string)
  default     = {}
}

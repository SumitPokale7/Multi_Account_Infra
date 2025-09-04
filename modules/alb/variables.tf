variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string) 
}

variable "security_group_ids" {
  type = list(string)
}

variable "internal" { 
  type = bool
}

variable "create_target_group" {
  description = "Whether to create a target group"
  type        = bool
  default     = true
}

variable "target_port" {
  type     = number
  nullable = true
  default  = null
}

variable "target_protocol" {
  type     = string
  nullable = true
  default  = null
}

variable "listener_port" {
  type = number
}

variable "listener_protocol" {
  type = string
}

variable "tags" {
  type = map(string)
}

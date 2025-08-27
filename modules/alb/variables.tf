variable "name" { type = string }
variable "vpc_id" { type = string }
variable "subnet_ids" { type = list(string) }
variable "security_group_ids" { type = list(string) }
variable "internal" { type = bool }

variable "target_port" { type = number }
variable "target_protocol" { type = string }

variable "listener_port" { type = number }
variable "listener_protocol" { type = string }

variable "tags" { type = map(string) }

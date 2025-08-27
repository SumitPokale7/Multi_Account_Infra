variable "name" { type = string }
variable "vpc_id" { type = string }
variable "subnet_ids" { type = list(string) }
variable "service_name" { type = string }
variable "tags" { type = map(string) }

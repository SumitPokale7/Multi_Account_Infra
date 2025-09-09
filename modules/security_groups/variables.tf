variable "vpc_id" {
  type = string
}

variable "security_group_name" {
  type = string
}

variable "security_groups" {
  description = "Map of security groups with rules"
  type = map(object({
    ingress = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
    egress = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
  }))
}

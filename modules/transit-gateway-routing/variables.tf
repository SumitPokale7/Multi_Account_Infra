variable "tgw_id" {
  type        = string
  description = "Transit Gateway ID"
}

variable "route_tables" {
  type = map(object({
    name         = string
    associations = list(string) # list of attachment IDs
    propagations = list(string) # list of attachment IDs
  }))
}

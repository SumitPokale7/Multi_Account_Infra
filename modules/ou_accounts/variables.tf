variable "accounts" {
  type = map(object({
    email = string
    name  = string
  }))
}

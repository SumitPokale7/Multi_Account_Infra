include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../modules/waf"
}

dependency "alb" {
  config_path = "../alb"
}

inputs = {
  resource_arn = dependency.alb.outputs.alb_arn
  web_acl_arn  = "arn:aws:wafv2:us-east-1:123456789012:regional/webacl/my-waf/abcd1234"
}

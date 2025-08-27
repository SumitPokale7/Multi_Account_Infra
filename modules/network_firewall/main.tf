# # ----------------------------
# # Rule Groups
# # ----------------------------
# resource "aws_networkfirewall_rule_group" "this" {
#   for_each = var.rule_groups

#   capacity = each.value.capacity
#   name     = each.key
#   type     = each.value.type

#   rule_group = jsonencode(each.value.rule_group)

#   tags = merge(var.tags, { Name = each.key })
# }

# # ----------------------------
# # Firewall Policy
# # ----------------------------
# resource "aws_networkfirewall_firewall_policy" "this" {
#   name = "${var.name}-policy"

#   firewall_policy = {
#     stateless_default_actions          = var.stateless_default_actions
#     stateless_fragment_default_actions = var.stateless_fragment_default_actions

#     stateful_rule_group_references = [
#       for k, rg in aws_networkfirewall_rule_group.this :
#       { resource_arn = rg.arn }
#       if var.rule_groups[k].type == "STATEFUL"
#     ]

#     stateless_rule_group_references = [
#       for k, rg in aws_networkfirewall_rule_group.this :
#       { priority = var.rule_groups[k].priority, resource_arn = rg.arn }
#       if var.rule_groups[k].type == "STATELESS"
#     ]
#   }

#   tags = merge(var.tags, { Name = "${var.name}-policy" })
# }

# # ----------------------------
# # Network Firewall
# # ----------------------------
# resource "aws_networkfirewall_firewall" "this" {
#   name                = var.name
#   vpc_id              = var.vpc_id
#   subnet_mappings     = [for subnet in var.subnet_ids : { subnet_id = subnet }]
#   firewall_policy_arn = aws_networkfirewall_firewall_policy.this.arn
#   delete_protection   = false

#   tags = merge(var.tags, { Name = var.name })
# }

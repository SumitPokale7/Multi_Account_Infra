# Rule Groups
resource "aws_networkfirewall_rule_group" "this" {
  for_each = var.rule_groups

  name        = each.key
  type        = each.value.type
  capacity    = each.value.capacity
  description = "Rule group for ${each.key}"

  rule_group {
    rules_source {
      stateless_rules_and_custom_actions {

        dynamic "stateless_rule" {
          for_each = each.value.rule_group.rules_source.stateless_rules_and_custom_actions.stateless_rules

          content {
            priority = stateless_rule.value.priority

            rule_definition {
              actions = stateless_rule.value.rule_definition.actions

              match_attributes {
                protocols = lookup(stateless_rule.value.rule_definition.match_attributes, "protocols", [])

                dynamic "source" {
                  for_each = lookup(stateless_rule.value.rule_definition.match_attributes, "source", [])
                  content {
                    address_definition = source.value.address_definition
                  }
                }

                dynamic "destination" {
                  for_each = lookup(stateless_rule.value.rule_definition.match_attributes, "destination", [])
                  content {
                    address_definition = destination.value.address_definition
                  }
                }

                dynamic "source_port" {
                  for_each = lookup(stateless_rule.value.rule_definition.match_attributes, "source_ports", [])
                  content {
                    from_port = source_port.value.from_port
                    to_port   = source_port.value.to_port
                  }
                }

                dynamic "destination_port" {
                  for_each = lookup(stateless_rule.value.rule_definition.match_attributes, "destination_ports", [])
                  content {
                    from_port = destination_port.value.from_port
                    to_port   = destination_port.value.to_port
                  }
                }
              }
            }
          }
        }

      }
    }
  }

  tags = merge(var.tags, { Name = each.key })
}

# Firewall Policy
resource "aws_networkfirewall_firewall_policy" "this" {
  name = "${var.name}-policy"

  firewall_policy {
    stateless_default_actions          = var.stateless_default_actions
    stateless_fragment_default_actions = var.stateless_fragment_default_actions

    # Add stateless rule group references
    dynamic "stateless_rule_group_reference" {
      for_each = {
        for k, rg in aws_networkfirewall_rule_group.this :
        k => {
          priority     = var.rule_groups[k].priority
          resource_arn = rg.arn
        }
        if var.rule_groups[k].type == "STATELESS"
      }
      content {
        priority     = stateless_rule_group_reference.value.priority
        resource_arn = stateless_rule_group_reference.value.resource_arn
      }
    }

    # Add stateful rule group references
    dynamic "stateful_rule_group_reference" {
      for_each = {
        for k, rg in aws_networkfirewall_rule_group.this :
        k => {
          resource_arn = rg.arn
        }
        if var.rule_groups[k].type == "STATEFUL"
      }
      content {
        resource_arn = stateful_rule_group_reference.value.resource_arn
      }
    }
  }
  tags = merge(var.tags, { Name = "${var.name}-policy" })
}

# Network Firewall
resource "aws_networkfirewall_firewall" "this" {
  name                = var.name
  vpc_id              = var.vpc_id
  delete_protection   = false
  firewall_policy_arn = aws_networkfirewall_firewall_policy.this.arn

  dynamic "subnet_mapping" {
    for_each = var.subnet_ids
    content {
      subnet_id = subnet_mapping.value
    }
  }

  tags = merge(var.tags, { Name = var.name })
}

include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../modules/network_firewall"
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    vpc_id = "vpc-mockapp2123"
    private_subnet_ids = {
      firewall = ["subnet-mock12345", "subnet-mock67890"]
    }
  }

  mock_outputs_allowed_terraform_commands = ["plan", "apply"]
}

inputs = {
  name       = "outbound-firewall"
  vpc_id     = dependency.vpc.outputs.vpc_id
  subnet_ids = dependency.vpc.outputs.private_subnet_ids["firewall"]

  stateless_default_actions          = ["aws:forward_to_sfe"]
  stateless_fragment_default_actions = ["aws:forward_to_sfe"]

  rule_groups = {
    allow-http = {
      capacity   = 100
      type       = "STATELESS"
      priority   = 10
      rule_group = {
        rules_source = {
          stateless_rules_and_custom_actions = {
            stateless_rules = [
              {
                rule_definition = {
                  actions = ["aws:pass"]
                  match_attributes = {
                    protocols   = [6]
                    source      = [{ address_definition = "0.0.0.0/0" }]
                    destination = [{ address_definition = "0.0.0.0/0" }]
                    source_ports      = [{ from_port = 0, to_port = 65535 }]
                    destination_ports = [{ from_port = 80, to_port = 80 }]
                  }
                }
                priority = 1
              }
            ]
          }
        }
      }
    }
  }

  tags = {
    Environment = "security-outbound"
  }
}

# include "root" {
#   path = find_in_parent_folders("root.hcl")
# }

terraform {
  source = "../../terraform/modules/ou_accounts"
}

inputs = {
  accounts = {
    tooling    = { email = "tooling+example@example.com",       name = "Tooling" }
    teamcity   = { email = "teamcity+example@example.com",      name = "TeamCity" }
    mezzo_eval = { email = "mezzo.eval+example@example.com",    name = "MezzoEval" }
    networking = { email = "networking+example@example.com",    name = "Networking" }
    smartvma   = { email = "smartvma.eval+example@example.com", name = "SmartVMAEval" }
    firewall   = { email = "firewall+example@example.com",      name = "FirewallAdmin" }
    mezzo_prod = { email = "mezzo.prod+example@example.com",    name = "MezzoProduction" }
    fulladv    = { email = "fulladv.prod+example@example.com",  name = "FullADVProduction" }
  }
}

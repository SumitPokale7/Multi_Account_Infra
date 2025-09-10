terraform {
  source = "../../../../modules/transit-gateway-routing"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "tgw" {
  config_path = "../transit-gateway"
  
  mock_outputs = {
    transit_gateway_id = "tgw-mockid12345"
  }
}

# Firewall Admin
dependency "dmz_tgw_attachments" {
  config_path = "../../firewall-admin/dmz-vpc/vpc"

  mock_outputs = {
    tgw_attachment_id = "mock-dmz_tgw_attachments-output"
  }
}

dependency "endpoints_tgw_attachments" {
  config_path = "../../firewall-admin/endpoints-vpc/vpc"

  mock_outputs = {
    tgw_attachment_id = "mock-endpoints_tgw_attachments-output"
  }
}

dependency "security_inbound_tgw_attachments" {
  config_path = "../../firewall-admin/security-inbound-vpc/vpc"

  mock_outputs = {
    tgw_attachment_id = "mock-security_inbound_tgw_attachments-output"
  }
}

dependency "security_outbound_tgw_attachments" {
  config_path = "../../firewall-admin/security-outbound-vpc/vpc"

  mock_outputs = {
    tgw_attachment_id = "mock-security_outbound_tgw_attachments-output"
  }
}

# Dev 
dependency "mezzo_beta_tgw_attachments" {
  config_path = "../../../dev/mezzo-beta/vpc"

  mock_outputs = {
    tgw_attachment_id = "mock-mezzo_beta_tgw_attachments-output"
  }
}

dependency "mezzo_eval_tgw_attachments" {
  config_path = "../../../dev/mezzo-eval/vpc"

  mock_outputs = {
    tgw_attachment_id = "mock-mezzo_eval_tgw_attachments-output"
  }
}

dependency "smartvma_eval_tgw_attachments" {
  config_path = "../../../dev/smartvma-eval/vpc"

  mock_outputs = {
    tgw_attachment_id = "mock-smartvma_eval_tgw_attachments-output"
  }
}

# Production
dependency "fulladv_prod_tgw_attachments" {
  config_path = "../../../production/fulladv-production/vpc"

  mock_outputs = {
    tgw_attachment_id = "mock-fulladv_prod_tgw_attachments-output"
  }
}

dependency "mezzo_prod_tgw_attachments" {
  config_path = "../../../production/mezzo-production/vpc"

  mock_outputs = {
    tgw_attachment_id = "mock-mezzo_prod_tgw_attachments-output"
  }
}

# Teamcity
dependency "teamcity_tgw_attachments" {
  config_path = "../../../teamcity/teamcity/vpc"

  mock_outputs = {
    tgw_attachment_id = "mock-teamcity_tgw_attachments-output"
  }
}

inputs = {
  tgw_id = dependency.tgw.outputs.transit_gateway_id

  route_tables = {
    # 1. DMZ RT - Entry point from internet, can reach all security and application VPCs
    dmz = {
      name         = "DMZ-RT"
      associations = [dependency.dmz_tgw_attachments.outputs.tgw_attachment_id]
      propagations = [
        dependency.security_inbound_tgw_attachments.outputs.tgw_attachment_id,
        dependency.security_outbound_tgw_attachments.outputs.tgw_attachment_id,
        dependency.endpoints_tgw_attachments.outputs.tgw_attachment_id,
        dependency.mezzo_beta_tgw_attachments.outputs.tgw_attachment_id,
        dependency.mezzo_eval_tgw_attachments.outputs.tgw_attachment_id,
        dependency.smartvma_eval_tgw_attachments.outputs.tgw_attachment_id,
        dependency.fulladv_prod_tgw_attachments.outputs.tgw_attachment_id,
        dependency.mezzo_prod_tgw_attachments.outputs.tgw_attachment_id,
        dependency.teamcity_tgw_attachments.outputs.tgw_attachment_id,
      ]
    }

    # 2. Inbound RT - For inbound internet traffic to applications
    inbound = {
      name         = "Inbound-RT"
      associations = [dependency.security_inbound_tgw_attachments.outputs.tgw_attachment_id]
      propagations = [
        dependency.dmz_tgw_attachments.outputs.tgw_attachment_id,
        dependency.security_outbound_tgw_attachments.outputs.tgw_attachment_id,
        dependency.endpoints_tgw_attachments.outputs.tgw_attachment_id,
        dependency.mezzo_beta_tgw_attachments.outputs.tgw_attachment_id,
        dependency.mezzo_eval_tgw_attachments.outputs.tgw_attachment_id,
        dependency.smartvma_eval_tgw_attachments.outputs.tgw_attachment_id,
        dependency.fulladv_prod_tgw_attachments.outputs.tgw_attachment_id,
        dependency.mezzo_prod_tgw_attachments.outputs.tgw_attachment_id,
        dependency.teamcity_tgw_attachments.outputs.tgw_attachment_id,
      ]
    }

    # 3. Outbound RT - For outbound internet traffic from applications
    outbound = {
      name         = "Outbound-RT"
      associations = [dependency.security_outbound_tgw_attachments.outputs.tgw_attachment_id]
      propagations = [
        dependency.dmz_tgw_attachments.outputs.tgw_attachment_id,
        dependency.security_inbound_tgw_attachments.outputs.tgw_attachment_id,
        dependency.endpoints_tgw_attachments.outputs.tgw_attachment_id,
        dependency.mezzo_beta_tgw_attachments.outputs.tgw_attachment_id,
        dependency.mezzo_eval_tgw_attachments.outputs.tgw_attachment_id,
        dependency.smartvma_eval_tgw_attachments.outputs.tgw_attachment_id,
        dependency.fulladv_prod_tgw_attachments.outputs.tgw_attachment_id,
        dependency.mezzo_prod_tgw_attachments.outputs.tgw_attachment_id,
        dependency.teamcity_tgw_attachments.outputs.tgw_attachment_id,
      ]
    }

    # 4. Endpoints RT - For AWS service endpoints access
    endpoints = {
      name         = "Endpoints-RT"
      associations = [dependency.endpoints_tgw_attachments.outputs.tgw_attachment_id]
      propagations = [
        dependency.dmz_tgw_attachments.outputs.tgw_attachment_id,
        dependency.security_inbound_tgw_attachments.outputs.tgw_attachment_id,
        dependency.security_outbound_tgw_attachments.outputs.tgw_attachment_id,
        dependency.mezzo_beta_tgw_attachments.outputs.tgw_attachment_id,
        dependency.mezzo_eval_tgw_attachments.outputs.tgw_attachment_id,
        dependency.smartvma_eval_tgw_attachments.outputs.tgw_attachment_id,
        dependency.fulladv_prod_tgw_attachments.outputs.tgw_attachment_id,
        dependency.mezzo_prod_tgw_attachments.outputs.tgw_attachment_id,
        dependency.teamcity_tgw_attachments.outputs.tgw_attachment_id,
      ]
    }

    # 5. Mezzo Beta - Dev environment with full connectivity
    mezzo_beta = {
      name         = "Mezzo-Beta-RT"
      associations = [dependency.mezzo_beta_tgw_attachments.outputs.tgw_attachment_id]
      propagations = [
        dependency.dmz_tgw_attachments.outputs.tgw_attachment_id,
        dependency.security_inbound_tgw_attachments.outputs.tgw_attachment_id,
        dependency.security_outbound_tgw_attachments.outputs.tgw_attachment_id,
        dependency.endpoints_tgw_attachments.outputs.tgw_attachment_id,
        dependency.teamcity_tgw_attachments.outputs.tgw_attachment_id,
        dependency.mezzo_eval_tgw_attachments.outputs.tgw_attachment_id,
        dependency.smartvma_eval_tgw_attachments.outputs.tgw_attachment_id,
      ]
    }

    # 6. Mezzo Eval - Dev environment with full connectivity
    mezzo_eval = {
      name         = "Mezzo-Eval-RT"
      associations = [dependency.mezzo_eval_tgw_attachments.outputs.tgw_attachment_id]
      propagations = [
        dependency.dmz_tgw_attachments.outputs.tgw_attachment_id,
        dependency.security_inbound_tgw_attachments.outputs.tgw_attachment_id,
        dependency.security_outbound_tgw_attachments.outputs.tgw_attachment_id,
        dependency.endpoints_tgw_attachments.outputs.tgw_attachment_id,
        dependency.teamcity_tgw_attachments.outputs.tgw_attachment_id,
        dependency.mezzo_beta_tgw_attachments.outputs.tgw_attachment_id,
        dependency.smartvma_eval_tgw_attachments.outputs.tgw_attachment_id,
      ]
    }

    # 7. SmartVMA Eval - Dev environment with full connectivity
    smartvma_eval = {
      name         = "SmartVMA-Eval-RT"
      associations = [dependency.smartvma_eval_tgw_attachments.outputs.tgw_attachment_id]
      propagations = [
        dependency.dmz_tgw_attachments.outputs.tgw_attachment_id,
        dependency.security_inbound_tgw_attachments.outputs.tgw_attachment_id,
        dependency.security_outbound_tgw_attachments.outputs.tgw_attachment_id,
        dependency.endpoints_tgw_attachments.outputs.tgw_attachment_id,
        dependency.teamcity_tgw_attachments.outputs.tgw_attachment_id,
        dependency.mezzo_beta_tgw_attachments.outputs.tgw_attachment_id,
        dependency.mezzo_eval_tgw_attachments.outputs.tgw_attachment_id,
      ]
    }

    # 8. Mezzo Production - Production with controlled access
    mezzo_prod = {
      name         = "Mezzo-Prod-RT"
      associations = [dependency.mezzo_prod_tgw_attachments.outputs.tgw_attachment_id]
      propagations = [
        dependency.dmz_tgw_attachments.outputs.tgw_attachment_id,
        dependency.security_inbound_tgw_attachments.outputs.tgw_attachment_id,
        dependency.security_outbound_tgw_attachments.outputs.tgw_attachment_id,
        dependency.endpoints_tgw_attachments.outputs.tgw_attachment_id,
        dependency.teamcity_tgw_attachments.outputs.tgw_attachment_id,
        dependency.fulladv_prod_tgw_attachments.outputs.tgw_attachment_id,
      ]
    }

    # 9. FullADV Production - Production with controlled access
    fulladv_prod = {
      name         = "FullADV-Prod-RT"
      associations = [dependency.fulladv_prod_tgw_attachments.outputs.tgw_attachment_id]
      propagations = [
        dependency.dmz_tgw_attachments.outputs.tgw_attachment_id,
        dependency.security_inbound_tgw_attachments.outputs.tgw_attachment_id,
        dependency.security_outbound_tgw_attachments.outputs.tgw_attachment_id,
        dependency.endpoints_tgw_attachments.outputs.tgw_attachment_id,
        dependency.teamcity_tgw_attachments.outputs.tgw_attachment_id,
        dependency.mezzo_prod_tgw_attachments.outputs.tgw_attachment_id,
      ]
    }

    # 10. TeamCity - CI/CD with access to all environments for deployments
    teamcity = {
      name         = "TeamCity-RT"
      associations = [dependency.teamcity_tgw_attachments.outputs.tgw_attachment_id]
      propagations = [
        dependency.dmz_tgw_attachments.outputs.tgw_attachment_id,
        dependency.security_inbound_tgw_attachments.outputs.tgw_attachment_id,
        dependency.security_outbound_tgw_attachments.outputs.tgw_attachment_id,
        dependency.endpoints_tgw_attachments.outputs.tgw_attachment_id,
        dependency.mezzo_beta_tgw_attachments.outputs.tgw_attachment_id,
        dependency.mezzo_eval_tgw_attachments.outputs.tgw_attachment_id,
        dependency.smartvma_eval_tgw_attachments.outputs.tgw_attachment_id,
        dependency.fulladv_prod_tgw_attachments.outputs.tgw_attachment_id,
        dependency.mezzo_prod_tgw_attachments.outputs.tgw_attachment_id,
      ]
    }
  }
}

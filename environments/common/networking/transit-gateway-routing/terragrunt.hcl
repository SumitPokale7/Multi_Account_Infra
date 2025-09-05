terraform {
  source = "../../../../modules/transit-gateway-routing"
}

include "root" {
  path = find_in_parent_folders("terragrunt.hcl")
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
}

dependency "endpoints_tgw_attachments" {
  config_path = "../../firewall-admin/endpoints-vpc/vpc"
}

dependency "security_inbound_tgw_attachments" {
  config_path = "../../firewall-admin/security-inbound-vpc/vpc"
}

dependency "security_outbound_tgw_attachments" {
  config_path = "../../firewall-admin/security-outbound-vpc/vpc"
}

# Dev 
dependency "mezzo_beta_tgw_attachments" {
  config_path = "../../../dev/mezzo-beta/vpc"
}

dependency "mezzo_eval_tgw_attachments" {
  config_path = "../../../dev/mezzo-eval/vpc"
}

dependency "smartvma_eval_tgw_attachments" {
  config_path = "../../../dev/smartvma-eval/vpc"
}

# Production
dependency "fulladv_prod_tgw_attachments" {
  config_path = "../../../production/fulladv-production/vpc"
}

dependency "mezzo_prod_tgw_attachments" {
  config_path = "../../../production/mezzo-production/vpc"
}

# Teamcity
dependency "teamcity_tgw_attachments" {
  config_path = "../../../teamcity/teamcity/vpc"
}

inputs = {
  tgw_id = dependency.tgw.outputs.transit_gateway_id

  route_tables = {
    # 1. DMZ RT
    dmz = {
      name         = "DMZ-RT"
      associations = [dependency.dmz_tgw_attachments.outputs.tgw_attachment_id] # DMZ VPC
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

    # 2. Inbound RT
    inbound = {
      name         = "Inbound-RT"
      associations = [dependency.security_inbound_tgw_attachments.outputs.tgw_attachment_id] # Security Inbound VPC
      propagations = [
        dependency.security_outbound_tgw_attachments.outputs.tgw_attachment_id,
        dependency.endpoints_tgw_attachments.outputs.tgw_attachment_id,
        dependency.mezzo_beta_tgw_attachments.outputs.tgw_attachment_id,
        dependency.mezzo_eval_tgw_attachments.outputs.tgw_attachment_id,
        dependency.smartvma_eval_tgw_attachments.outputs.tgw_attachment_id,
        dependency.fulladv_prod_tgw_attachments.outputs.tgw_attachment_id,
        dependency.mezzo_prod_tgw_attachments.outputs.tgw_attachment_id,
        dependency.teamcity_tgw_attachments.outputs.tgw_attachment_id,
        dependency.dmz_tgw_attachments.outputs.tgw_attachment_id
      ]
    }

    # 3. Outbound RT
    outbound = {
      name         = "Outbound-RT"
      associations = [dependency.security_outbound_tgw_attachments.outputs.tgw_attachment_id,] # Security Outbound VPC
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

    # 4. Endpoints RT
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

    # 5. Mezzo Beta
    mezzo_beta = {
      name         = "Mezzo-Beta-RT"
      associations = [dependency.mezzo_beta_tgw_attachments.outputs.tgw_attachment_id]
      propagations = [
        dependency.dmz_tgw_attachments.outputs.tgw_attachment_id,
        dependency.security_inbound_tgw_attachments.outputs.tgw_attachment_id,
        dependency.endpoints_tgw_attachments.outputs.tgw_attachment_id,
        dependency.security_outbound_tgw_attachments.outputs.tgw_attachment_id
      ]
    }

    # 6. Mezzo Eval
    mezzo_eval = {
      name         = "Mezzo-Eval-RT"
      associations = [dependency.mezzo_eval_tgw_attachments.outputs.tgw_attachment_id]
      propagations = [
        dependency.dmz_tgw_attachments.outputs.tgw_attachment_id,
        dependency.security_inbound_tgw_attachments.outputs.tgw_attachment_id,
        dependency.endpoints_tgw_attachments.outputs.tgw_attachment_id,
        dependency.security_outbound_tgw_attachments.outputs.tgw_attachment_id
      ]
    }

    # 7. SmartVMA Eval
    smartvma_eval = {
      name         = "SmartVMA-Eval-RT"
      associations = [dependency.smartvma_eval_tgw_attachments.outputs.tgw_attachment_id]
      propagations = [
        dependency.dmz_tgw_attachments.outputs.tgw_attachment_id,
        dependency.security_inbound_tgw_attachments.outputs.tgw_attachment_id,
        dependency.endpoints_tgw_attachments.outputs.tgw_attachment_id,
        dependency.security_outbound_tgw_attachments.outputs.tgw_attachment_id
      ]
    }

    # 8. Mezzo Production
    mezzo_prod = {
      name         = "Mezzo-Prod-RT"
      associations = [dependency.mezzo_prod_tgw_attachments.outputs.tgw_attachment_id]
      propagations = [
        dependency.dmz_tgw_attachments.outputs.tgw_attachment_id,
        dependency.security_inbound_tgw_attachments.outputs.tgw_attachment_id,
        dependency.endpoints_tgw_attachments.outputs.tgw_attachment_id,
        dependency.security_outbound_tgw_attachments.outputs.tgw_attachment_id
      ]
    }

    # 9. FullADV Prod
    fulladv_prod = {
      name         = "FullADV-Prod-RT"
      associations = [dependency.fulladv_prod_tgw_attachments.outputs.tgw_attachment_id]
      propagations = [
        dependency.dmz_tgw_attachments.outputs.tgw_attachment_id,
        dependency.security_inbound_tgw_attachments.outputs.tgw_attachment_id,
        dependency.endpoints_tgw_attachments.outputs.tgw_attachment_id,
        dependency.security_outbound_tgw_attachments.outputs.tgw_attachment_id
      ]
    }

    # 10. TeamCity
    teamcity = {
      name         = "TeamCity-RT"
      associations = [dependency.teamcity_tgw_attachments.outputs.tgw_attachment_id]
      propagations = [
        dependency.dmz_tgw_attachments.outputs.tgw_attachment_id,
        dependency.security_inbound_tgw_attachments.outputs.tgw_attachment_id,
        dependency.endpoints_tgw_attachments.outputs.tgw_attachment_id,
        dependency.security_outbound_tgw_attachments.outputs.tgw_attachment_id
      ]
    }
  }
}

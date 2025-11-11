# Multi-Account AWS Infrastructure with Terraform & Terragrunt

This repository provides a **production-ready**, **modular**, **multi-account** AWS infrastructure setup using **Terraform** and **Terragrunt**. It implements a comprehensive hub-and-spoke network architecture with centralized security controls, supporting multiple environments (**dev**, **production**) with shared networking and security resources.

## 🌟 Key Features

- **🏗️ Multi-Account Architecture**: Separate AWS accounts for networking, security, development, and production workloads
- **🔒 Centralized Security**: Hub-and-spoke model with AWS Network Firewall, Gateway Load Balancer, and WAF
- **🌐 Transit Gateway Routing**: Intelligent routing between VPCs with custom route tables
- **📦 Modular Design**: Reusable Terraform modules for all AWS resources
- **🔄 DRY Configuration**: Terragrunt eliminates code duplication across environments
- **🛡️ Security-First**: Built-in network segmentation, firewall rules, and security groups
- **📊 Observability**: VPC Flow Logs and CloudWatch integration

---

## 📁 Repository Structure

```bash
.
├── environments/          # Environment-specific configurations
│   ├── common/           # Shared infrastructure accounts
│   │   ├── networking/   # Transit Gateway, routing (Account: 635566486000)
│   │   └── firewall-admin/ # Security VPCs, firewalls (Account: 33753707000)
│   │       ├── dmz-vpc/
│   │       ├── endpoints-vpc/
│   │       ├── security-inbound-vpc/
│   │       └── security-outbound-vpc/
│   ├── dev/              # Development workloads (Account: 390259467000)
│   │   ├── mezzo-dev/
│   │   ├── mezzo-dev-test/
│   │   └── smartvma-eval/
│   └── production/       # Production workloads (Account: 327903111000)
│       ├── fulladv-production/
│       └── mezzo-production/
└── modules/              # Reusable Terraform modules
    ├── alb/
    ├── ec2/
    ├── gwlb/
    ├── gwlbe/
    ├── network_firewall/
    ├── rds/
    ├── security_groups/
    ├── transit-gateway/
    ├── transit-gateway-routing/
    ├── vpc/
    └── waf/
```

---

## 🏛️ Architecture Overview

### Network Architecture

The infrastructure implements a **centralized inspection model** with:

1. **DMZ VPC (10.30.0.0/16)**: Internet-facing Application Load Balancer with WAF protection
2. **Security Inbound VPC (10.32.0.0/16)**: Inspects all inbound traffic via AWS Network Firewall
3. **Security Outbound VPC (10.33.0.0/16)**: Inspects all outbound traffic to the internet
4. **Endpoints VPC (10.31.0.0/16)**: Centralized AWS service endpoints (SSM, EC2 Messages)
5. **Application VPCs**: Workload-specific VPCs in dev and production accounts

### Transit Gateway Routing

Custom route tables provide:
- **DMZ Route Table**: Entry point from internet
- **Inbound Route Table**: Traffic from DMZ to applications
- **Outbound Route Table**: Application traffic to internet
- **Endpoints Route Table**: Shared AWS service access
- **Application Route Tables**: Environment-specific routing

---

## 🚀 Getting Started

### Prerequisites

Ensure you have the following tools installed:

```bash
# Required versions
Terraform >= 1.9.7, < 1.10.0
Terragrunt = 0.86.1
AWS CLI (latest)
```

### AWS Account Setup

This infrastructure requires the following IAM roles in each account:

```bash
# In each workload account (dev, prod, firewall-admin)
TerraformExecutionRole - ARN: arn:aws:iam::{ACCOUNT_ID}:role/TerraformExecutionRole

# In networking account (635566486000) - for remote state
TerraformStateExecutionRole - ARN: arn:aws:iam::635566486000:role/TerraformStateExecutionRole
```

### Authentication

Configure AWS credentials using either profiles or environment variables:

**Option 1: AWS Profiles**
```bash
# ~/.aws/credentials
[networking_account]
aws_access_key_id = YOUR_KEY
aws_secret_access_key = YOUR_SECRET

[firewall_account]
aws_access_key_id = YOUR_KEY
aws_secret_access_key = YOUR_SECRET

[dev_account]
aws_access_key_id = YOUR_KEY
aws_secret_access_key = YOUR_SECRET

[prod_account]
aws_access_key_id = YOUR_KEY
aws_secret_access_key = YOUR_SECRET
```

**Option 2: Environment Variables**
```bash
export AWS_PROFILE=networking_account
# OR
export AWS_ACCESS_KEY_ID="your-key"
export AWS_SECRET_ACCESS_KEY="your-secret"
```

---

## 📖 Usage Guide

### 1. Deploy Shared Infrastructure (Networking)

Start with the Transit Gateway in the networking account:

```bash
cd environments/common/networking/transit-gateway
terragrunt plan
terragrunt apply
```

### 2. Deploy Security Infrastructure (Firewall Admin)

Deploy security VPCs with inspection capabilities:

```bash
cd environments/common/firewall-admin/

# Deploy each security VPC
cd security-inbound-vpc/vpc && terragrunt apply
cd ../../security-outbound-vpc/vpc && terragrunt apply
cd ../../dmz-vpc/vpc && terragrunt apply
cd ../../endpoints-vpc/vpc && terragrunt apply
```

### 3. Configure Transit Gateway Routing

```bash
cd environments/common/networking/transit-gateway-routing
terragrunt apply
```

### 4. Deploy Application Environments

**Development Environment:**
```bash
cd environments/dev/mezzo-dev/

# Deploy in order
terragrunt run-all plan   # Preview all changes
terragrunt run-all apply  # Apply all configurations
```

**Production Environment:**
```bash
cd environments/production/mezzo-production/
terragrunt run-all apply
```

### 5. Deploy All Environments at Once

```bash
cd environments/
terragrunt run-all plan
terragrunt run-all apply --terragrunt-non-interactive
```

---

## 🔧 Adding a New Environment

### Example: Adding a New Production Application

1. **Create directory structure:**
```bash
mkdir -p environments/production/my-new-app/{vpc,security-groups,ec2,rds}
```

2. **Create VPC configuration** (`environments/production/my-new-app/vpc/terragrunt.hcl`):
```hcl
include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../modules/vpc"
}

dependency "tgw" {
  config_path = "../../../common/networking/transit-gateway"
}

inputs = {
  vpc_cidr   = "10.22.0.0/16"  # Choose unused CIDR
  vpc_name   = "MyNewApp_VPC"

  private_subnets = [
    { cidr = "10.22.1.0/24", az = "us-east-2a", purpose = "db" },
    { cidr = "10.22.2.0/24", az = "us-east-2a", purpose = "app" },
    { cidr = "10.22.3.0/24", az = "us-east-2a", purpose = "tgw" },
  ]

  attach_to_tgw      = true
  transit_gateway_id = dependency.tgw.outputs.transit_gateway_id

  tgw_routes = {
    DMZ              = "10.30.0.0/16"
    Endpoints        = "10.31.0.0/16"
    SecurityInbound  = "10.32.0.0/16"
    SecurityOutbound = "10.33.0.0/16"
  }
  
  common_tags = {
    Environment = "production"
    Project     = "my-new-app"
    ManagedBy   = "terraform"
  }
}
```

3. **Add security groups** (`security-groups/terragrunt.hcl`):
```hcl
include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../modules/security_groups"
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  vpc_id              = dependency.vpc.outputs.vpc_id
  security_group_name = "my-new-app"
  
  security_groups = {
    app-sg = {
      ingress = [
        { from_port = 443, to_port = 443, protocol = "tcp", 
          cidr_blocks = [dependency.vpc.outputs.vpc_cidr_block] }
      ]
      egress = [
        { from_port = 0, to_port = 0, protocol = "-1", 
          cidr_blocks = ["0.0.0.0/0"] }
      ]
    }
  }
}
```

4. **Update Transit Gateway routing** to include the new VPC:

Edit `environments/common/networking/transit-gateway-routing/terragrunt.hcl`:

```hcl
dependency "my_new_app_tgw_attachments" {
  config_path = "../../../production/my-new-app/vpc"
}

inputs = {
  route_tables = {
    # ... existing route tables ...
    
    my_new_app = {
      name         = "MyNewApp-RT"
      associations = [dependency.my_new_app_tgw_attachments.outputs.tgw_attachment_id]
      propagations = [
        dependency.dmz_tgw_attachments.outputs.tgw_attachment_id,
        dependency.security_inbound_tgw_attachments.outputs.tgw_attachment_id,
        # ... other VPCs you want to communicate with
      ]
    }
  }
}
```

---

## 🔐 Security Best Practices

### Network Segmentation
- Each environment has its own VPC with dedicated CIDR blocks
- Transit Gateway route tables control inter-VPC communication
- Security groups follow principle of least privilege

### Inspection Points
- **Inbound Traffic**: DMZ → Security Inbound VPC → Applications
- **Outbound Traffic**: Applications → Security Outbound VPC → Internet
- **East-West Traffic**: Can be routed through security VPCs if needed

### WAF Protection
- AWS Managed Rules for common vulnerabilities
- Rate limiting to prevent DDoS
- Custom rules for application-specific threats

### Secrets Management
- Database passwords should use AWS Secrets Manager (not hardcoded)
- EC2 private keys stored in SSM Parameter Store
- IAM roles for cross-account access

---

## 📊 Monitoring and Logging

### VPC Flow Logs
Enabled on Transit Gateway for traffic analysis:
```hcl
enable_flow_logs           = true
flow_logs_retention_days   = 30
```

### WAF Logging
Configure in `waf/terragrunt.hcl`:
```hcl
waf_logging_enabled = true
waf_log_destination_configs = [
  "arn:aws:s3:::my-waf-logs-bucket"
]
```

---

## 🛠️ Module Documentation

### VPC Module
Creates VPC with public/private subnets, Internet Gateway, NAT Gateway, and Transit Gateway attachment.

**Key Outputs:**
- `vpc_id`
- `private_subnet_ids` (grouped by purpose: db, app, tgw, etc.)
- `public_subnet_ids`
- `tgw_attachment_id`

---

## 🐛 Troubleshooting

### Common Issues

**1. Transit Gateway attachment pending acceptance**
```bash
# Check attachment status
aws ec2 describe-transit-gateway-vpc-attachments \
  --filters "Name=state,Values=pendingAcceptance"

# The code includes auto-acceptance with aws_ec2_transit_gateway_vpc_attachment_accepter
```

**2. Dependency errors**
```bash
# Use mock outputs for planning
terragrunt plan --terragrunt-ignore-dependency-errors

# Apply dependencies first
cd dependency-module && terragrunt apply
```

**3. Route conflicts**
```bash
# Check route table
aws ec2 describe-route-tables --route-table-ids rtb-xxx

# Verify CIDR blocks don't overlap
```

---

## 📈 Cost Optimization

### Estimated Monthly Costs (us-east-2)

| Resource | Quantity | Cost/Month |
|----------|----------|------------|
| Transit Gateway | 1 | ~$36 |
| TGW Attachments | 9 VPCs | ~$324 |
| NAT Gateways | 2 | ~$65 |
| Network Firewall | 2 AZs | ~$730 |
| GWLB | 2 | ~$36 |
| EC2 t2.micro | 12 | ~$100 |
| ALB | 1 | ~$23 |
| **Total** | | **~$1,314/month** |


### Cost Reduction Tips
- Use t3/t4g instance types instead of t2
- Reduce NAT Gateway count (use single AZ for dev)
- Set `create_rds_cluster = false` for unused databases
- Enable S3 Gateway Endpoints (free)

---

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/new-module`)
3. Test your changes in a non-production account
4. Submit a pull request with detailed description

---

## 📝 Additional Resources

- [AWS Multi-Account Strategy](https://docs.aws.amazon.com/whitepapers/latest/organizing-your-aws-environment/organizing-your-aws-environment.html)
- [AWS Network Firewall](https://docs.aws.amazon.com/network-firewall/)
- [Terragrunt Documentation](https://terragrunt.gruntwork.io/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

---

## 🔄 Version History

- **v1.0.0** (2025-01): Initial release with multi-account architecture
- Terraform: 1.9.7
- Terragrunt: 0.86.1
- AWS Provider: 6.12.0

# Multi Account Infra

This repository provides a modular, multi-account AWS infrastructure setup using Terraform and Terragrunt. It is designed to support multiple environments (dev, production, teamcity) and common networking/security resources, following best practices for scalable cloud architecture.

## Structure

- **environments/**: Contains environment-specific configurations.
  - `common/`: Shared resources (firewall, networking, organization accounts).
  - `dev/`, `production/`, `teamcity/`: Account-specific infrastructure (VPCs, EC2, RDS, security groups).
- **modules/**: Reusable Terraform modules for AWS resources (alb, ec2, gwlb, network_firewall, rds, security_groups, transit-gateway, vpc, waf, etc).
- **Mutil_Account_Diagram.png**: Visual diagram of the multi-account architecture.
- **.gitignore**: Standard git ignore file.

## Key Features

- **Terragrunt**: Used for managing remote state, DRY configuration, and dependency management.
- **Terraform Modules**: Each AWS resource is modularized for reuse and maintainability.
- **Multi-Environment Support**: Easily deploy infrastructure for dev, production, and CI/CD (teamcity) environments.
- **Security & Networking**: Includes modules for VPCs, security groups, firewalls, WAF, transit gateways, and endpoints.

## Getting Started

1. **Install Prerequisites**
   - [Terraform](https://www.terraform.io/downloads.html)
   - [Terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/install/)
   - AWS CLI & credentials

2. **Clone the Repository**
   ```sh
   git clone <repo-url>
   cd Multi_Account_Infra
   ```

3. **Configure AWS Credentials**
   - Set up your AWS credentials as required for your environment.

4. **Deploy Infrastructure**
   - Navigate to the desired environment folder (e.g., `environments/dev/mezzo-beta/vpc/`).
   - Run Terragrunt:
     ```sh
     terragrunt init
     terragrunt plan
     terragrunt apply
     ```

## Folder Overview

- `environments/common/`: Shared networking and security resources.
- `environments/dev/`, `environments/production/`, `environments/teamcity/`: Environment-specific deployments.
- `modules/`: Core Terraform modules for AWS resources.

## Customization

- Modify variables in `variables.tf` within each module to suit your requirements.
- Use Terragrunt HCL files to manage dependencies and remote state.

## Diagram

Refer to `Mutil_Account_Diagram.png` for a high-level overview of the architecture.

## License

For more details, refer to the documentation in each environment/module folder and the architecture diagram.

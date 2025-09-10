This repository provides a **modular**, **multi-account** AWS infrastructure setup using **Terraform** and **Terragrunt**. It supports multiple environments—**dev**, **production**, and **teamcity**—with shared networking and security resources, following best practices for **scalable**, **secure**, and **maintainable** cloud architecture.

---

## 📁 Project Structure

```bash
.
├── environments/
│   ├── common/        # Shared Accounts: networking, firewall-admin
│   ├── dev/           # Development environment
│   ├── production/    # Production environment
│   └── teamcity/      # teamcity environment
└── modules/           # Reusable Terraform modules for AWS resources
```


## Key Directories
**environments/** – Contains Terragrunt HCL configurations per environment.

**common/** – Shared networking/security modules.

**dev/, production/, teamcity/** – Account/environment-specific infrastructure.

**modules/** – Terraform modules for AWS services such as: alb, ec2, gwlb, network_firewall, rds, security_groups, transit-gateway, vpc, waf, etc.

## Features
- Terragrunt Integration Handles remote state, DRY configuration, and cross-module dependencies.

- Modular Terraform Design Infrastructure code is organized into reusable and composable modules.

- Multi-Environment Support
Easily deploy dev, production, and TeamCity environments in isolation.

- Security & Networking First

    - Built-in modules for:
    
    - VPCs & subnets

    - AWS Network Firewall

    - Transit Gateway

    - WAF, endpoints, security groups

🛠 Getting Started
1. Install Prerequisites
Make sure the following tools are installed:

        Terraform v1.9.7
        
        Terragrunt v0.86.1
        
        AWS CLI

2. You can authenticate Terraform to AWS either by assuming a role or by using a credentials profile.
Use environment variables or ~/.aws/credentials:

    ``` bash
    export AWS_PROFILE=your-profile-name
    ```

3. Deploy Infrastructure
Navigate to the desired environment directory, e.g.:

    ```bash
    cd environments/dev/mezzo-beta/
    Run the following commands:
    ```
    ```bash
    terragrunt plan --all
    terragrunt apply --all
    ```

4. Or Navigate to the environments directory, e.g.:

    ```bash
    cd environments/
    Run the following commands:
    ```
    ```bash
    terragrunt plan --all
    terragrunt apply --all
    ```
    It will Deploy All the resources one by one!

## ⚙️ Customization
- Edit variables.tf in each module to adjust defaults.

- Use Terragrunt .hcl files to:
    - Pass input variables

    - Configure remote state backends

    - Define dependencies between modules

| Path                       | Description                                  |
| -------------------------- | -------------------------------------------- |
| `environments/common/`     | Shared infrastructure (networking, firewall) |
| `environments/dev/`        | Development environment                      |
| `environments/production/` | Production environment                       |
| `environments/teamcity/`   | TeamCity environment |
| `modules/`                 | Reusable Terraform modules for AWS resources |


📌 Notes
All environments are configured using Terragrunt's hierarchical structure for consistency and reuse.

State is managed remotely per environment to avoid conflicts.

Resource names follow environment-specific naming conventions to ensure isolation.
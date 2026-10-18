# EC2 Heartbeat AWS Infrastructure

Terraform project for deploying and managing the AWS infrastructure required by the **EC2 Heartbeat Python Automation** project.

## Related Application Project

This infrastructure is designed to support the following project:

**EC2 Heartbeat Python Automation**

https://github.com/Andrey242-GH/EC2_Heartbeat_Python_Automation

The projects are separated into two repositories:

```text
EC2_Heartbeat_Python_Automation
        |
        |  Application / Python Automation
        |
        v
EC2_Heartbeat_AWS_Infrastructure
        |
        |  Terraform Infrastructure as Code
        |
        v
AWS
```

### Application Repository

```text
EC2_Heartbeat_Python_Automation
```

Contains the Python automation project.

Repository:

```text
https://github.com/Andrey242-GH/EC2_Heartbeat_Python_Automation
```

### Infrastructure Repository

```text
EC2_Heartbeat_AWS_Infrastructure
```

Contains the Terraform configuration used to provision and manage the AWS infrastructure required by the application.

Keeping the application and infrastructure in separate repositories provides a clear separation between:

```text
Application Code              Infrastructure as Code
------------------------      --------------------------
Python                        Terraform
Automation logic              AWS resource definitions
Application dependencies      Infrastructure configuration
```

---

## Technologies

This infrastructure project uses:

- Terraform for Infrastructure as Code (IaC)
- AWS CLI for AWS authentication and management
- GitHub Codespaces as the development environment
- GitHub Codespaces Secrets for AWS credentials
- AWS EC2 for compute infrastructure

---

## Repository Structure

```text
EC2_Heartbeat_AWS_Infrastructure/
│
├── main.tf
├── providers.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
├── user-data.sh
├── .gitignore
├── README.md
│
└── docs/
    ├── 01-INSTALL-TERRAFORM-AWSCLI.md
    ├── 02-AWS-CREDENTIALS-CODESPACES.md
    └── 03-TERRAFORM-WORKFLOW.md
```

---

## Documentation

Detailed setup and usage instructions are available in the `docs` directory.

### 1. Install Terraform and AWS CLI

Instructions for installing Terraform and AWS CLI inside GitHub Codespaces.

```text
docs/01-INSTALL-TERRAFORM-AWSCLI.md
```

### 2. Configure AWS Credentials

Instructions for securely storing AWS credentials using GitHub Codespaces Secrets.

```text
docs/02-AWS-CREDENTIALS-CODESPACES.md
```

### 3. Terraform Workflow

Instructions for initializing Terraform, planning infrastructure changes, deploying resources, modifying infrastructure, and destroying resources.

```text
docs/03-TERRAFORM-WORKFLOW.md
```

---

# Prerequisites

Before deploying the infrastructure, make sure you have:

- An AWS account
- GitHub Codespaces access
- Terraform installed
- AWS CLI installed
- AWS credentials configured as GitHub Codespaces Secrets

The following environment variables should be available inside the Codespace:

```text
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_DEFAULT_REGION
```

---

# Verify the Environment

Check Terraform:

```bash
terraform --version
```

Check AWS CLI:

```bash
aws --version
```

Verify AWS authentication:

```bash
aws sts get-caller-identity
```

Make sure the returned AWS account and IAM identity are the ones you intend to use before running Terraform.

---

# Quick Start

## 1. Initialize Terraform

```bash
terraform init
```

## 2. Format the Configuration

```bash
terraform fmt
```

## 3. Validate the Configuration

```bash
terraform validate
```

## 4. Create a Terraform Plan

```bash
terraform plan -out=tfplan
```

## 5. Review the Plan

```bash
terraform show tfplan
```

Review the proposed infrastructure changes before continuing.

## 6. Deploy the Infrastructure

```bash
terraform apply tfplan
```

---

# View Deployed Resources

View resources managed by Terraform:

```bash
terraform state list
```

View Terraform outputs:

```bash
terraform output
```

---

# Modify the Infrastructure

After changing the Terraform configuration:

```bash
terraform fmt
terraform validate
terraform plan
terraform apply
```

Always review the Terraform plan before applying infrastructure changes.

---

# Destroy the Infrastructure

Before destroying resources, preview what Terraform intends to remove:

```bash
terraform plan -destroy
```

Review the destruction plan carefully.

Then destroy the infrastructure:

```bash
terraform destroy
```

Terraform will ask for confirmation before deleting the managed resources.

---

# Security

AWS credentials must never be stored directly in the Terraform configuration or committed to Git.

Do not store credentials in:

```text
main.tf
providers.tf
variables.tf
terraform.tfvars
.env
README.md
user-data.sh
```

AWS credentials for this project should be stored using GitHub Codespaces Secrets.

The authentication flow is:

```text
GitHub Codespaces Secrets
        |
        v
Environment Variables
        |
        +--> AWS_ACCESS_KEY_ID
        +--> AWS_SECRET_ACCESS_KEY
        +--> AWS_DEFAULT_REGION
        |
        v
AWS CLI / Terraform
        |
        v
AWS
```

---

# Recommended Terraform Workflow

For creating or modifying infrastructure:

```text
Verify AWS Identity
        |
        v
terraform init
        |
        v
terraform fmt
        |
        v
terraform validate
        |
        v
terraform plan
        |
        v
Review Plan
        |
        v
terraform apply
```

For destroying infrastructure:

```text
terraform plan -destroy
        |
        v
Review Resources
        |
        v
terraform destroy
```

---

# Important

Always review a Terraform plan before applying infrastructure changes.

For normal deployments:

```text
PLAN -> REVIEW -> APPLY
```

For resource destruction:

```text
PLAN DESTROY -> REVIEW -> DESTROY
```

Do not commit AWS credentials, Terraform state files, or sensitive configuration to the repository.
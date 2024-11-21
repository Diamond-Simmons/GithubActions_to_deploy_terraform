```markdown
# GithubActions_to_deploy_terraform
infrastructure setup using GithubActions to deploy terraform template

This repository demonstrates how to use GitHub Actions to deploy infrastructure using Terraform. The infrastructure consists of an AWS VPC, Subnet, Internet Gateway, Route Table, Security Group, and an EC2 instance.

## Prerequisites

- An AWS account with proper permissions to create the resources defined in `main.tf`.
- An S3 bucket created manually to store the Terraform backend state file.
- Git and VS Code installed locally.
- Terraform installed locally (optional for manual verification).

## Repository Structure

```plaintext
GithubActions_to_deploy_terraform/
├── .gitignore        # Terraform-specific .gitignore template
├── .github/
│   └── workflows/
│       └── terraform.yaml  # GitHub Actions workflow configuration
├── src/
│   └── main.tf       # Terraform configuration file
```

## Steps to Recreate and Test

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/GithubActions_to_deploy_terraform.git
cd GithubActions_to_deploy_terraform
```

### 2. Set Up the Backend S3 Bucket

Create an S3 bucket manually in AWS to store the Terraform state file. Update the `main.tf` file with your S3 bucket name and region:

```hcl
terraform {
  backend "s3" {
    bucket = "your-s3-bucket-name"
    key    = "terraform.tfstate"
    region = "your-region"
  }
}
```

### 3. Configure GitHub Secrets

Add the following secrets to your GitHub repository:
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_SESSION_TOKEN` (if applicable)

These are required for GitHub Actions to interact with your AWS account.

### 4. Push Your Changes

```bash
git add .
git commit -m "Initial setup of Terraform infrastructure"
git push
```

### 5. Verify the Workflow

Go to the **GitHub Actions** tab in your repository and confirm the `Terraform` workflow runs successfully. This workflow will:
1. Initialize Terraform (`terraform init`).
2. Plan the infrastructure deployment (`terraform plan`).
3. Apply the infrastructure (`terraform apply -auto-approve`).

### 6. Check Backend State

After the workflow completes, verify that the `terraform.tfstate` file is stored in the S3 bucket specified in the backend configuration.

### 7. Destroy the Infrastructure

When you're ready to destroy the infrastructure:
1. Comment out the `Terraform apply` step in `terraform.yaml`.
2. Uncomment the `Terraform destroy` step.
3. Push your changes:

```bash
git add .
git commit -m "Switch to destroy infrastructure"
git push
```

Verify that the infrastructure is destroyed and the `terraform.tfstate` file is cleared from the S3 bucket.

### 8. Clean Up

- Manually delete the S3 bucket to complete the cleanup process.

## Notes

- **Manual Bucket Management**: Since the S3 bucket for the Terraform backend is created manually, it must also be deleted manually.
- **Workflow Customization**: Adjust the Terraform version, AWS region, and instance details in `main.tf` as needed.
- **Testing**: Feel free to clone this repository and test the setup in your own AWS environment.

## Troubleshooting

- **AWS Credentials**: Ensure your AWS credentials are correctly configured in GitHub Secrets.
- **S3 Bucket**: Verify that the S3 bucket exists and matches the name specified in `main.tf`.
- **GitHub Actions**: Check the logs in the Actions tab for any errors during the workflow execution.

Happy coding!
```
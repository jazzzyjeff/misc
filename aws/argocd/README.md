# AWS EKS Argo CD

## Overview
This project deploys Argo CD on an AWS EKS cluster to provide a GitOps continuous delivery platform for Kubernetes applications.

The deployment includes:
- EKS cluster managed via Terraform
- Argo CD installed using the official Helm chart
- External access through an AWS Application Load Balancer (ALB) with a public DNS hostname managed in Route 53
- TLS termination at the ALB using AWS ACM certificates
- Authentication and Single Sign-On (SSO) integrated with AWS IAM Identity Center (formerly AWS SSO) for secure user access

## Usage
1. In order to setup SSO integration with IAM Identity Center you can follow the guide [here](https://argo-cd.readthedocs.io/en/stable/operator-manual/user-management/identity-center/)
2. You would then need to create `user` and `group` if one doesn't exist already. Add the group to the above application itself. Ensure the user has email address, if created through Teraform you can actually not apply one. If not done then you will get `bad input` when signing into the Argo CD portal.
3. `cd aws/argocd/terraform`
4. Create `variables.auto.tfvars` file and input the following variables
    ```bash
    region = "enter aws region"
    service = "argocd"
    domain  = "enter in the route53 domain"
    sso = {
        "url" = "Enter in IAM Identity Center sign-in URL"
        "certificate"= "Base64 of IAM Identity Center Certificate"
        "group_id" = "IAM Identity Center group id"
    }
    ```
5. `terraform init` > `terraform plan` > `terraform apply -auto-approve`

# SCP lab

Service control policies attached to the organisation root:

| Policy | Effect |
| ------ | ------ |
| `deny-all-outside-requested-regions` | Denies everything outside `region`, except global services (`aws-marketplace`, `cloudfront`, `iam`, `organizations`, `route53`, `support`) |
| `deny-org-escape` | Denies leaving the organisation |

State is stored in the shared backend bucket (SSM `/backend`, i.e. `jt-m3`) at `terraform/misc/aws/sap/labs/scp/terraform.tfstate`.

## Usage

Run from this folder against the management account:

```bash
export AWS_REGION=eu-west-2
BACKEND=$(aws ssm get-parameter --name /backend --query Parameter.Value --output text)

sed -e "s|\${BACKEND}|$BACKEND|" -e "s|\${SERVICE}|misc|" -e "s|\${AWS_REGION}|$AWS_REGION|" backend.tf.tmpl > backend.tf
sed -e "s|\${SERVICE}|misc|" -e "s|\${AWS_REGION}|$AWS_REGION|" variables.auto.tfvars.tmpl > variables.auto.tfvars

terraform init
terraform plan
terraform apply
```

`backend.tf` and `variables.auto.tfvars` are generated and gitignored.

## Migrating from local state (one-off)

If `terraform.tfstate` still exists in this folder, generate `backend.tf` as above, then:

```bash
terraform init -migrate-state     # answer "yes" to copy the local state to S3
terraform state list              # expect 2 aws_organizations_policy + 2 attachments
terraform plan                    # expect only the pending SCP change, nothing else
```

Once that looks right, delete the local copies: `rm terraform.tfstate terraform.tfstate.backup`.

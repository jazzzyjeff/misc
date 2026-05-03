# AWS Lambda S3 File System

## Overview

A minimal test of [Amazon S3 Files](https://aws.amazon.com/about-aws/whats-new/2026/04/amazon-s3-files/), 
which lets you mount an S3 bucket as a file system directly in Lambda.

## What this does

Deploys a Lambda function with an S3 Files file system mounted at `/mnt/s3`, backed by an S3 bucket. 
The function supports five test actions to exercise the mount:

| Action | What it tests |
|--------|--------------|
| `list` | Mount is accessible, directory listing works |
| `write` | Can create files through the mount |
| `read` | Read-after-write consistency |
| `rename` | Instant rename (vs copy+delete with raw S3 API) |
| `stat` | POSIX file metadata |

## Prerequisites

- Terraform >= 1.0
- AWS CLI v2
- An AWS account with S3 Files available in your region

## Usage

```bash
cp variables.auto.tfvars.tmpl variables.auto.tfvars
# edit variables.auto.tfvars with your region etc.

terraform init
terraform apply
```

Invoke the function:

```bash
aws lambda invoke \
  --function-name s3-file-system \
  --cli-binary-format raw-in-base64-out \
  --payload '{"action":"list"}' /dev/stdout
```

Run through all actions in order:

```bash
for action in list write read rename stat; do
  echo "--- $action ---"
  aws lambda invoke \
    --function-name s3-file-system \
    --cli-binary-format raw-in-base64-out \
    --payload "{\"action\":\"$action\"}" /dev/stdout
  echo
done
```

Then confirm the files landed in S3:

```bash
aws s3 ls s3://<your-bucket-name>/ --recursive
```

## Teardown

```bash
terraform destroy
```

> The file system is created with `force_destroy = true` so destroy won't block 
> on pending S3 exports. Don't use this in production.

# TF-GCP-INFRA

This is a terraform module that sets up Google Cloud VPC

## Commands

The commands that we need to know are:

``` shell
terraform init
terraform validate
terraform plan
terraform apply
terraform destroy
```

## Pre-requisites
1. Terraform must be installed
2. Google Cloud CLI must be installed
3. Google Cloud CLI must be authenticated

## Creating infra
1. Running `terraform apply` after successful init and validation should create infra for you.
2. Make sure that the main.tf is properly setup with necessary variable names.
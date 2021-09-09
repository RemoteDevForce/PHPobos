# Terraform AWS ECS Infrastructure

The foundation of your infrastructure using Amazon Elastic Container Service

This terraform script will create a VPC + Bastion Instance + ECS Cluster

## Instructions

This should only really be called from your GitHub Action but you can call it locally if testing.

To Plan/apply/destroy
```
export ENV=staging
make tf-plan
make tf-apply
make tf-destroy
```

# Project PHPobos

A tutorial for building an AWS ECS stack with Terraform, GitHub, and CI/CD Actions to host/build/deploy a PHP application.

This is a mono-repo and directories are as follows:

* `.github/workflows` - All the GitHub Action code. Plan/Apply/Destroy Jobs for Infra/ECS Service. Build docker image.
* `app` - An experimental Symfony application to create a portal on our remote lab on Phobos.
* `docker` - The dockerfile for local & prod containers for our highly experimental 4th dimension portal opener app.
* `terraform` - All the terraform code for our AWS ECS Stack.
  * `terraform/tf-aws-init` - Start here to create ssh keys & buckets for our state files
  * `terraform/tf-aws-infra` - Base infrastructure for AWS such as bastion and ECS servers.
  * `terraform/tf-aws-service` - The ECS Service for hosting our application.
 
 ## Prerequisites

These examples have only been tested on a Mac but Linux should also work. Windows users can try Linux sub-shell at their own risk.

 First make sure you have done the following:
 
 * Installed Terraform v1+
 * Signed up for AWS and created an Admin IAM Account. 
 * Installed AWS-CLI and setup IAM credentials in `./aws/credentials`
 * `jq` installed locally for config loading in makefiles & the `empty-s3-bucket.sh` script.
 
 ## Instructions
 
 1. Configure your IAM credentials in `.aws/credentials`
 1. `cd` into the `terraform/tf-aws-init` and run `make tf-plan-staging`
 1. If things look good, run `make tf-apply-staging` to create the backend tf state s3 buckets.
 
 ## Production Ready
 
 I would recommended reviewing ALL files.
 
 * Add TF state locking via DynamoDB - [read more](https://www.terraform.io/docs/language/settings/backends/s3.html)
 
 ## References
 
 Review the slides here
 
 Checkout my blog post here
# Project PHPobos

A tutorial for building an AWS ECS stack with Terraform, GitHub, and CI/CD Actions to host/build/deploy a PHP application.

This is a mono-repo and directories are as follows:

* `.github/workflows` - All the GitHub Action code.
* `terraform` - All the terraform code for our AWS ECS Stack.
  * `terraform/aws-init` - Start here to create ssh keys & buckets for our state files
  * `terraform/aws-infra` - Base infrastructure for AWS such as bastion and ECS servers.
  * `terraform/aws-service` - The ECS Service for hosting our application.
* `app` - An experimental Symfony application to create a portal on our remote lab on Phobos.
  * `app/docker` - The dockerfiles for local & prod containers for our questionably moral 4th dimension portal opener app.
 
 ## Prerequisites

These examples have only been tested on a Mac but Linux should also work.

 ## Instructions
 
 First make sure you have done the following:
 
 * Installed Terraform v1+
 * Signed up for AWS and created an Admin IAM Account. 
 * Installed AWS-CLI and setup IAM credentials in `./aws/credentials`
 * _Optional_ - `jq` installed so the `empty-s3-bucket.sh` script can remove all objects from S3 Buckets when cleaning up AWS resources.
 
 ## References
 
 Review the slides here
 
 Checkout my blog post here
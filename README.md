# Project PHPobos

![Project PHPobos Logo](https://www.remotedevforce.com/wp-content/uploads/2021/09/project-phpobos.png)

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

Goto the repository page and click "Use this template" to copy it to your own namespace.

![Project PHPobos](https://www.remotedevforce.com/wp-content/uploads/2021/09/github-phpobos-repo.png)

Clone down your version of the repo to your machine.

### AWS Init Terraform
Now setup the base S3 buckets/root ssh key which is used to access the bastion instance.
 1. `cd` into the `terraform/tf-aws-init` and run `make tf-plan-staging`
 1. If things look good, run `make tf-apply-staging` to create the backend tf state s3 buckets.

### AWS Infra Terraform

### Docker Build Action

### AWS Service Terraform

### SSH to the ECS Agent Instance

First add an entry in your `.ssh/config` file that has your bastion IP and tell it to forward your SSH Agent.

```
Host staging-phpobos
 HostName 34.208.225.123       #(replace with your bastion public IP address)
 User ec2-user
 IdentityFile ~/.ssh/id_rsa    #(replace if you used a different key)
 ForwardAgent yes
```

Then head over to you [EC2 Dashboard](https://us-west-2.console.aws.amazon.com/ec2/v2/home?region=us-west-2#Instances:sort=instanceId) and select on of the *-ecs-asg instances to copy the private IP address.

SSH to bastion `ssh ec2-user@bastion.ip.address.here` and then once on the server, SSH to the private ip of the ECS EC2 Instance `ssh ec2-user@ecs.instance.ip.here`

Then you can run `docker ps` once on an ECS Host to make sure you see the ecs-agent running.

## Notes

Update the `.github/CODEOWNERS` file with your username/team. This file restricts who can change `.github/workflows`.

## Getting Production Ready

I would recommended reviewing ALL files. A few things I can think of are:

 * Add RDS or some database layer
 * Restrict GitHub IAM Keys to just have what is needed (God Made aka `Administrator Access` is not recommended) 
 * Add TF state locking via DynamoDB - [read more](https://www.terraform.io/docs/language/settings/backends/s3.html)
 * Add Encryption to ECR, ALB, ECS, etc.
   * Add SSL to ALB (Best to host domain DNS with Route53 and use AWS Certificate Manager)
 * Add an RDS config in tf-aws-infra
 * Blue/Green Deployment (faster rollback)
 * Inject `.env.local` or environment variable overrides to configure staging/prod app

## More Info

[Terraform AWS Init Readme](terraform/tf-aws-init/README.md)
[Terraform AWS Infrastructure Readme](terraform/tf-aws-infra/README.md)
[Terraform AWS ECS Service Readme](terraform/tf-aws-service/README.md)
[Docker Readme](docker/README.md)

## References

Review the slides [here](https://docs.google.com/presentation/d/1jCc5mVfBomk9e_JRizkk570Fu_sqngFXb-TeQy1Ladw/edit?usp=sharing)

Checkout my blog post here

## Need Help?

Hire us at [Remote Dev Force](https://www.remotedevforce.com) to train, build, and secure your cloud infrastructure. We have some of the best DevOps & Programmers in the United States ready to help.

--- 
![Remote Dev Force Logo](https://www.remotedevforce.com/wp-content/uploads/2019/02/RemoteDevForce_Logo.png)

© 2021. A Remote Dev Force Project. MIT. Made with 💪 in Las Vegas, NV. 🇺🇸
# Terraform AWS ECS Infrastructure

The foundation of your infrastructure using Amazon Elastic Container Service

This terraform script will create a VPC + Bastion Instance + ECS Cluster

## Instructions

This should only really be called from your GitHub Action but you can call it locally if testing.

To Plan/apply
```
make tf-action
#check plan looks good
TF_ACTION=apply make tf-action

#to destroy, run:
TF_ACTION=destroy make tf-action
```

### How to hop to an ECS Agent Instance

First add an entry in your `.ssh/config` file that has your bastion IP and tell it to forward your SSH Agent.

```
Host bastion.ip.address.here
  ForwardAgent yes
```

Then head over to you [EC2 Dashboard](https://us-west-2.console.aws.amazon.com/ec2/v2/home?region=us-west-2#Instances:sort=instanceId) and select on of the *-ecs-asg instances to copy the private IP address.

SSH to bastion `ssh ec2-user@bastion.ip.address.here` and then once on the server, SSH to the private ip of the ECS EC2 Instance `ssh ec2-user@ecs.instance.ip.here`

Then you can run `docker ps` once there to make sure you see the ecs-agent running.

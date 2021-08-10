variable "env_name" {
	description = "The environment name"
}

variable "s3prefix" {
	description = "The s3 prefix needed for storing remote tf state files"
}

variable "region" {
	description = "The region for the aws VPC"
}

variable "azs" {
	description = "List of availability zones"
}

variable "cidr" {
	default = "10.0.0.0/16"
}

variable "database_subnets" {
	default = "10.0.121.0/24,10.0.122.0/24,10.0.123.0/24"
}

variable "cache_subnets" {
	default = "10.0.111.0/24,10.0.112.0/24,10.0.113.0/24"
}

variable "private_subnets" {
	default = "10.0.101.0/24,10.0.102.0/24,10.0.103.0/24"
}

variable "public_subnets" {
	default = "10.0.1.0/24,10.0.2.0/24,10.0.3.0/24"
}

variable "amazon_amis" {
	description = "Amazon Linux AMI for bastion instances"
	type = map(string)
	default = {
		us-west-2 = "ami-0c2b8ca1dad447f8a"
	}
}

// Update these AMI IDs - http://docs.aws.amazon.com/AmazonECS/latest/developerguide/launch_container_instance.html
variable "amazon_ecs_amis" {
	description = "Amazon Linux AMI for ECS servers"
	type = map(string)
	default = {
		"us-west-2" = "ami-0d034e17dea566f28"
	}
}

variable "ecs_instance_type" {
	description = "The AWS ECS instance type"
	default = "t2.medium"
}

variable "asg_min" {
	description = "Min numbers of EC2s in ASG"
	default = "1"
}

variable "asg_max" {
	description = "Max numbers of EC2s in ASG"
	default = "1"
}

variable "asg_desired" {
	description = "Desired numbers of EC2s in ASG"
	default = "1"
}

variable "single_nat_gateway" {
	default = true
}

variable "one_nat_gateway_per_az" {
	default = false
}
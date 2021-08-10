variable "ssh_key_path" {
  description = "The root ssh key used to access AWS resources."
}

variable "region" {
  description = "The target AWS region."
}

variable "s3prefix" {
  description = "An s3 bucket prefix for all your terraform state files."
}

variable "env_name" {
  description = "Environment name"
}
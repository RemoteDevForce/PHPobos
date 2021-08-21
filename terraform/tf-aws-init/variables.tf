variable "ssh_key_path" {
  description = "The root ssh key used to access AWS resources."
}

variable "region" {
  description = "The target AWS region."
}

variable "app_name" {
  description = "A unique name for your app. Used as prefix for naming AWS Resources. No spaces, special chars."
}

variable "env_name" {
  description = "Environment name"
}
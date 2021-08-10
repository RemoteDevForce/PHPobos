provider "aws" {
  region = var.region
}

# Where to store the terraform state file. Note that you won't have a local tfstate file, because its stored remotely.
terraform {
  required_version = ">= 1.0.3"
  backend "s3" {
    bucket = "${var.s3prefix}-${var.env_name}-tf-states-${var.region}"
    key    = "infrastructure.tfstate"
    region = var.region
  }
}
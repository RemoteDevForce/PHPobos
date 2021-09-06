provider "aws" {
  region = var.region
}

# Keys are tied to a AWS region
resource "aws_key_pair" "root" {
  key_name = "root-${var.env_name}-${var.region}-ssh-key"
  public_key = file(var.ssh_key_path)
}

# The main terraform states s3 bucket
resource "aws_s3_bucket" "terraform-states" {
  bucket = "${var.env_name}-${var.region}-${var.app_name}-tfstate"
  acl = "private"

  # This is good for just incase the file gets corrupted or something bad.
  versioning {
    enabled = true
  }

  # Send all S3 logs to another bucket
  logging {
    target_bucket = aws_s3_bucket.terraform-logs.id
    target_prefix = "logs/"
  }

  tags = {
    Name = "${var.env_name}-${var.region}-${var.app_name}-tfstate"
    ManagedBy = "Terraform"
    Env = var.env_name
    App = var.app_name
    Region = var.region
  }
}

# This terraform bucket is an audit log of anything that happens to the state bucket
resource "aws_s3_bucket" "terraform-logs" {
  bucket = "${var.env_name}-${var.region}-${var.app_name}-tfstate-logs"
  acl = "log-delivery-write"

  tags = {
    Name = "${var.env_name}-${var.region}-${var.app_name}-tfstate-logs"
    ManagedBy = "Terraform"
    Env = var.env_name
    App = var.app_name
    Region = var.region
  }
}

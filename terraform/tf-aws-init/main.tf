provider "aws" {
  region = var.region
}

# Keys are tied to a AWS region
resource "aws_key_pair" "root" {
  key_name   = "root-${var.env_name}-${var.app_name}-ssh-key"
  public_key = file(var.ssh_key_path)

  tags = {
    Name      = "root-${var.env_name}-${var.app_name}-ssh-key"
    ManagedBy = "Terraform"
    Env       = var.env_name
    App       = var.app_name
    Region    = var.region
  }
}

# The main terraform states s3 bucket
resource "aws_s3_bucket" "terraform-states" {
  bucket = "${var.env_name}-${var.app_name}-${var.region}-tfstate"
  acl    = "private"

  # This is good for just incase the file gets corrupted or something bad.
  versioning {
    enabled = true
  }

  # Send all S3 logs to another bucket
  logging {
    target_bucket = aws_s3_bucket.audit-logs.id
    target_prefix = "tfstates-logs/"
  }

  tags = {
    Name      = "${var.env_name}-${var.app_name}-${var.region}-tfstate"
    ManagedBy = "Terraform"
    Env       = var.env_name
    App       = var.app_name
    Region    = var.region
  }
}

# This terraform bucket is an audit log of anything that happens to the state bucket
resource "aws_s3_bucket" "audit-logs" {
  bucket = "${var.env_name}-${var.app_name}-${var.region}-audit-logs"
  acl    = "log-delivery-write"

  tags = {
    Name      = "${var.env_name}-${var.app_name}-${var.region}-audit-logs"
    ManagedBy = "Terraform"
    Env       = var.env_name
    App       = var.app_name
    Region    = var.region
  }
}

# Store release build configs and application configs
resource "aws_s3_bucket" "configs" {
  bucket = "${var.env_name}-${var.app_name}-${var.region}-configs"
  acl    = "private"

  versioning {
    enabled = true
  }

  logging {
    target_bucket = aws_s3_bucket.audit-logs.id
    target_prefix = "config-logs/"
  }

  tags = {
    Name      = "${var.env_name}-${var.app_name}-${var.region}-configs"
    ManagedBy = "Terraform"
    Env       = var.env_name
    App       = var.app_name
    Region    = var.region
  }
}

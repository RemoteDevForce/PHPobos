provider "aws" {
  region = var.region
}

resource "aws_key_pair" "root" {
  key_name = "root-${var.env_name}-${var.region}-ssh-key"
  public_key = file(var.ssh_key_path)
}

resource "aws_s3_bucket" "terraform-logs" {
  bucket = "${var.app_name}-${var.env_name}-tfstate-logs-${var.region}"
  acl = "log-delivery-write"

  tags = {
    Name = "${var.app_name}-${var.env_name}-tfstate-logs-${var.region}"
    ManagedBy = "Terraform"
    Environment = var.env_name
  }
}

# The main terraform states s3 bucket
resource "aws_s3_bucket" "terraform-states" {
  bucket = "${var.app_name}-${var.env_name}-tfstate-${var.region}"
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
    Name = "${var.app_name}-${var.env_name}-tfstate-${var.region}"
    ManagedBy = "Terraform"
    Environment = var.env_name
  }
}
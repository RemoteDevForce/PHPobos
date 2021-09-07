provider "aws" {
  region = var.region
}

terraform {
  required_version = ">= 1.0.3"
  backend "s3" {
    bucket = "${var.env_name}-${var.app_name}-${var.region}-tfstate"
    key    = "infrastructure.tfstate"
    region = var.region
  }
}

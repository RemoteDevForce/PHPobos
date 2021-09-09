provider "aws" {
  region = var.region
}

# Where we store state for the ECS Service
terraform {
  backend "s3" {
    bucket = "${var.env_name}-${var.app_name}-${var.region}-tfstate"
    key    = "ecs-app-service.tfstate"
    region = var.region
  }
}

# Import infrastructure state
data "terraform_remote_state" "infrastructure_state" {
  backend = "s3"
  config = {
    bucket = "${var.env_name}-${var.app_name}-${var.region}-tfstate"
    key = "infrastructure.tfstate"
    region = var.region
  }
}

resource "aws_ecr_repository" "app" {
  name                 = "${var.env_name}-${var.app_name}-ecr"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    ManagedBy = "Terraform"
    Name = "${var.env_name}-${var.app_name}-ecr"
    Env = var.env_name
    App = var.app_name
    Region      = var.region
  }
}
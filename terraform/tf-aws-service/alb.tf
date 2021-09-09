resource "aws_alb" "alb" {
  name            = "${var.env_name}-${var.app_name}"
  internal        = var.internal_alb
  subnets         = [data.terraform_remote_state.infrastructure_state.outputs.public_subnet_ids]
  security_groups = [aws_security_group.alb-application.id]

  enable_deletion_protection = var.delete_protection

  tags = {
    ManagedBy = "Terraform"
    Name      = "${var.env_name}-${var.app_name}"
    Env       = var.env_name
    App       = var.app_name
    Region    = var.region
  }
}

resource "aws_alb_target_group" "application" {
  name     = "${var.env_name}-${var.app_name}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.infrastructure_state.outputs.vpc_id
  tags = {
    ManagedBy = "Terraform"
    Name      = "${var.env_name}-${var.app_name}"
    Env       = var.env_name
    App       = var.app_name
    Region    = var.region
  }
}

resource "aws_alb_listener" "application" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.application.arn
    type             = "forward"
  }
}

resource "aws_security_group" "alb-application" {
  name        = "${var.env_name}-${var.app_name}-alb-sg"
  description = "Controls all access to the ALB"
  vpc_id      = data.terraform_remote_state.infrastructure_state.outputs.vpc_id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    ManagedBy = "Terraform"
    Name      = "${var.env_name}-${var.app_name}-alb-sg"
    Env       = var.env_name
    App       = var.app_name
    Region    = var.region
  }
}

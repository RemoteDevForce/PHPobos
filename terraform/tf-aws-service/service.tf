data "template_file" "service_definition" {
  template = file("${path.module}/service.json")

  vars = {
    env_name        = var.env_name
    region          = var.region
    app_name        = var.app_name
    image_name      = var.image_name
    docker_tag      = var.docker_tag
    max_memory      = var.max_memory
    reserved_memory = var.reserved_memory
  }
}

resource "aws_ecs_task_definition" "application" {
  family                = "${var.env_name}-${var.app_name}"
  container_definitions = data.template_file.service_definition.rendered
}

resource "aws_iam_role" "application" {
  name               = "${var.env_name}-${var.app_name}"
  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
          "ecs.amazonaws.com"
        ]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

// Check this out if you want HTTPS - https://www.terraform.io/docs/providers/aws/r/alb_listener.html
// However, this requires you have an aws managed certificate ARN for a domain you own.
resource "aws_iam_role_policy_attachment" "ecs_service_role" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
  role       = aws_iam_role.application.name
}

resource "aws_ecs_service" "application" {
  name            = "${var.env_name}-${var.app_name}"
  cluster         = data.terraform_remote_state.infrastructure_state.outputs.cluster_id
  task_definition = aws_ecs_task_definition.application.arn
  desired_count   = var.service_desired
  iam_role        = aws_iam_role.application.arn

  load_balancer {
    target_group_arn = aws_alb_target_group.application.arn
    container_name   = "${var.env_name}-${var.app_name}"
    container_port   = 80
  }

  ordered_placement_strategy {
    type  = "binpack"
    field = "memory"
  }

  depends_on = [
    aws_ecs_task_definition.application,
    aws_alb_target_group.application,
    aws_alb.alb,
    aws_alb_listener.application
  ]
}

resource "aws_iam_role" "ecs_autoscale_role" {
  name               = "${var.env_name}-${var.app_name}-ecs-autoscale-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "application-autoscaling.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "ecs_autoscale_role_attach" {
  name       = "ecs-autoscale-role-attach"
  roles      = [aws_iam_role.ecs_autoscale_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceAutoscaleRole"
}
# Elastic Container Service
resource "aws_ecs_cluster" "ecs" {
  name = "${var.env_name}-${var.app_name}-ecs"

  setting {
    name  = "containerInsights"
    value = "disabled"
  }
}

# Launch configuration used by ASG
resource "aws_launch_configuration" "ecs-lc" {
  name_prefix   = "${var.env_name}-${var.app_name}-ecs-lc-"
  image_id      = lookup(var.amazon_ecs_amis, var.region)
  instance_type = var.ecs_instance_type
  key_name      = "root-${var.env_name}-${var.app_name}-ssh-key"
  security_groups = [
    aws_security_group.ecs.id
  ]
  iam_instance_profile        = aws_iam_role.ecs_iam_role.name
  associate_public_ip_address = false
  user_data                   = data.template_file.userdata.rendered

  lifecycle {
    create_before_destroy = true

    ignore_changes = [
      ebs_block_device,
      metadata_options,
      root_block_device
    ]
  }

  depends_on = [
    aws_ecs_cluster.ecs
  ]
}

# IAM
resource "aws_iam_instance_profile" "ecs_profile" {
  name = "${var.env_name}-${var.app_name}-${var.region}-ecs-role"
  role = aws_iam_role.ecs_iam_role.name
}

# A shared IAM role for jenkins which has two policy documents attached. IAM stuff & ECS EC2 Role.
resource "aws_iam_role" "ecs_iam_role" {
  name               = "${var.env_name}-${var.app_name}-${var.region}-ecs-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume-role-policy.json
}

resource "aws_iam_role_policy_attachment" "ecs_attach" {
  role       = aws_iam_role.ecs_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

# Userdata
data "template_file" "userdata" {
  template = file("ecs_user_data.tpl")

  vars = {
    env_name = var.env_name
    app_name = var.app_name
    region   = var.region
  }
}

# SG
resource "aws_security_group" "ecs" {
  name        = "${var.env_name}-${var.app_name}-${var.region}-ecs-sg"
  description = "Container Instance Allowed Ports"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 1
    to_port   = 65535
    protocol  = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {
    from_port = 1
    to_port   = 65535
    protocol  = "udp"
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
    Name        = "${var.env_name}-${var.app_name}-${var.region}-ecs-sg"
    ManagedBy   = "Terraform"
    Environment = var.env_name
    App         = var.app_name
    Region      = var.region
  }

  lifecycle {
    create_before_destroy = true
  }
}

# ASG
resource "aws_autoscaling_policy" "ecs-scale-up" {
  name                   = "${var.env_name}-${var.app_name}-${var.region}-ecs-policy-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.ecs-asg.name
}

resource "aws_cloudwatch_metric_alarm" "ecs-alarm-up" {
  alarm_name                = "${var.env_name}-${var.app_name}-${var.region}-ecs-mem-high"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = "1"
  metric_name               = "MemoryReservation"
  namespace                 = "AWS/ECS"
  period                    = "300"
  statistic                 = "Average"
  threshold                 = "75"
  alarm_description         = "This metric monitors ECS RAM utilization"
  insufficient_data_actions = []
  alarm_actions = [
    aws_autoscaling_policy.ecs-scale-up.arn
  ]
  dimensions = {
    ClusterName = aws_ecs_cluster.ecs.name
  }

  depends_on = [
    aws_autoscaling_policy.ecs-scale-up
  ]
}

resource "aws_autoscaling_policy" "ecs-scale-down" {
  name                   = "${var.env_name}-${var.app_name}-${var.region}-ecs-policy-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.ecs-asg.name
}

resource "aws_cloudwatch_metric_alarm" "ecs-alarm-down" {
  alarm_name                = "${var.env_name}-${var.app_name}-${var.region}-ecs-mem-low"
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = "1"
  metric_name               = "MemoryReservation"
  namespace                 = "AWS/ECS"
  period                    = "300"
  statistic                 = "Average"
  threshold                 = "50"
  alarm_description         = "This metric monitors ECS RAM utilization"
  insufficient_data_actions = []
  alarm_actions = [
    aws_autoscaling_policy.ecs-scale-down.arn
  ]
  dimensions = {
    ClusterName = aws_ecs_cluster.ecs.name
  }

  depends_on = [
    aws_autoscaling_policy.ecs-scale-down,
    aws_cloudwatch_metric_alarm.ecs-alarm-up
  ]
}

resource "aws_autoscaling_group" "ecs-asg" {
  vpc_zone_identifier  = module.vpc.private_subnets
  name                 = "${var.env_name}-${var.app_name}-${var.region}-ecs-asg"
  max_size             = var.asg_max
  min_size             = var.asg_min
  desired_capacity     = var.asg_desired
  force_delete         = true
  launch_configuration = aws_launch_configuration.ecs-lc.name
  health_check_type    = "EC2"

  tag {
    key                 = "Name"
    value               = "${var.env_name}-${var.app_name}-${var.region}-ecs-asg"
    propagate_at_launch = "true"
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_launch_configuration.ecs-lc
  ]
}

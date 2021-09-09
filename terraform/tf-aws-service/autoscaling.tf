
resource "aws_appautoscaling_target" "application" {
  max_capacity       = var.service_max
  min_capacity       = var.service_min
  resource_id        = "service/${data.terraform_remote_state.infrastructure_state.outputs.ecs_cluster_name}/${aws_ecs_service.application.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  role_arn           = aws_iam_role.ecs_autoscale_role.arn

  depends_on = [aws_ecs_service.application]
}

resource "aws_appautoscaling_policy" "scale-up" {
  name               = "${var.env_name}-${var.app_name}-scale-up"
  service_namespace  = "ecs"
  resource_id        = "service/${data.terraform_remote_state.infrastructure_state.outputs.ecs_cluster_name}/${aws_ecs_service.application.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }

  depends_on = [aws_appautoscaling_target.application]
}

resource "aws_cloudwatch_metric_alarm" "application-cpu-scale-up" {
  alarm_name          = "${var.env_name}-${var.app_name}-cpu-up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "300"
  statistic           = "Average"
  threshold           = "var.cpu_scale_up"
  alarm_description   = "Monitors ECS CPU Utilization"
  alarm_actions       = [aws_appautoscaling_policy.scale-up.arn]

  dimensions = {
    ClusterName = data.terraform_remote_state.infrastructure_state.outputs.ecs_cluster_name
    ServiceName = aws_ecs_service.application.name
  }

  depends_on = [aws_appautoscaling_policy.scale-up]
}

resource "aws_appautoscaling_policy" "scale-down" {
  name               = "${var.env_name}-${var.app_name}-scale-down"
  service_namespace  = "ecs"
  resource_id        = "service/${data.terraform_remote_state.infrastructure_state.outputs.ecs_cluster_name}/${aws_ecs_service.application.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = -1
    }
  }

  depends_on = [aws_appautoscaling_target.application]
}

resource "aws_cloudwatch_metric_alarm" "application-scale-down" {
  alarm_name          = "${var.env_name}-${var.app_name}-cpu-down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "300"
  statistic           = "Average"
  threshold           = var.cpu_scale_down
  alarm_description   = "Monitors ECS CPU Utilization"
  alarm_actions       = [aws_appautoscaling_policy.scale-down.arn]

  dimensions = {
    ClusterName = data.terraform_remote_state.infrastructure_state.outputs.ecs_cluster_name
    ServiceName = aws_ecs_service.application.name
  }

  depends_on = [
    aws_appautoscaling_policy.scale-down,
    aws_cloudwatch_metric_alarm.application-cpu-scale-up
  ]
}

resource "aws_cloudwatch_metric_alarm" "asg_cpu_high" {
  alarm_name        = "${local.name_prefix}-high-cpu"
  alarm_description = "Average CPU utilisation across the Auto Scaling Group is above 80%."

  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  threshold           = 80

  namespace   = "AWS/EC2"
  metric_name = "CPUUtilization"
  statistic   = "Average"
  period      = 300

  dimensions = {
    AutoScalingGroupName = var.autoscaling_group_name
  }

  alarm_actions = [
    aws_sns_topic.alerts.arn
  ]

  ok_actions = [
    aws_sns_topic.alerts.arn
  ]

  treat_missing_data = "notBreaching"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-high-cpu"
    }
  )
}

resource "aws_cloudwatch_metric_alarm" "target_group_unhealthy" {
  alarm_name        = "${local.name_prefix}-unhealthy-targets"
  alarm_description = "Alarm when healthy targets fall below 2."

  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  threshold           = 2

  namespace   = "AWS/ApplicationELB"
  metric_name = "HealthyHostCount"
  statistic   = "Minimum"
  period      = 60

  dimensions = {
    LoadBalancer = var.load_balancer_arn_suffix
    TargetGroup  = var.target_group_arn_suffix
  }

  alarm_actions = [
    aws_sns_topic.alerts.arn
  ]

  ok_actions = [
    aws_sns_topic.alerts.arn
  ]

  treat_missing_data = "breaching"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-unhealthy-targets"
    }
  )
}

resource "aws_cloudwatch_metric_alarm" "alb_5xx_errors" {
  alarm_name        = "${local.name_prefix}-alb-5xx-errors"
  alarm_description = "Alarm when the Application Load Balancer returns 5XX errors."

  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  threshold           = 5

  namespace   = "AWS/ApplicationELB"
  metric_name = "HTTPCode_ELB_5XX_Count"
  statistic   = "Sum"
  period      = 300

  dimensions = {
    LoadBalancer = var.load_balancer_arn_suffix
  }

  alarm_actions = [
    aws_sns_topic.alerts.arn
  ]

  ok_actions = [
    aws_sns_topic.alerts.arn
  ]

  treat_missing_data = "notBreaching"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-alb-5xx-errors"
    }
  )
}

resource "aws_cloudwatch_metric_alarm" "asg_insufficient_capacity" {
  alarm_name        = "${local.name_prefix}-asg-insufficient-capacity"
  alarm_description = "Alarm when the Auto Scaling Group has fewer than 2 InService instances."

  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  threshold           = 2

  namespace   = "AWS/AutoScaling"
  metric_name = "GroupInServiceInstances"
  statistic   = "Minimum"
  period      = 60

  dimensions = {
    AutoScalingGroupName = var.autoscaling_group_name
  }

  alarm_actions = [
    aws_sns_topic.alerts.arn
  ]

  ok_actions = [
    aws_sns_topic.alerts.arn
  ]

  treat_missing_data = "breaching"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-asg-insufficient-capacity"
    }
  )
}

resource "aws_cloudwatch_metric_alarm" "ec2_status_check_failed" {

  alarm_name        = "${local.name_prefix}-status-check-failed"
  alarm_description = "Alarm when one or more EC2 instances fail status checks."

  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  threshold           = 1

  namespace   = "AWS/EC2"
  metric_name = "StatusCheckFailed"
  statistic   = "Maximum"
  period      = 60

  dimensions = {
    AutoScalingGroupName = var.autoscaling_group_name
  }

  alarm_actions = [
    aws_sns_topic.alerts.arn
  ]

  ok_actions = [
    aws_sns_topic.alerts.arn
  ]

  treat_missing_data = "notBreaching"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-status-check-failed"
    }
  )
}

resource "aws_cloudwatch_metric_alarm" "alb_target_response_time" {

  alarm_name        = "${local.name_prefix}-alb-target-response-time"
  alarm_description = "Alarm when ALB target response time exceeds 2 seconds."

  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  threshold           = 2

  namespace   = "AWS/ApplicationELB"
  metric_name = "TargetResponseTime"
  statistic   = "Average"
  period      = 300

  dimensions = {
    LoadBalancer = var.load_balancer_arn_suffix
  }

  alarm_actions = [
    aws_sns_topic.alerts.arn
  ]

  ok_actions = [
    aws_sns_topic.alerts.arn
  ]

  treat_missing_data = "notBreaching"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-alb-target-response-time"
    }
  )
}

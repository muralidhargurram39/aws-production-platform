resource "aws_cloudwatch_metric_alarm" "nginx_errors" {

  alarm_name = "${local.name_prefix}-nginx-errors"

  alarm_description = "Alarm when NGINX logs contain ERROR entries."

  namespace = "${local.name_prefix}/Application"

  metric_name = "NginxErrors"

  statistic = "Sum"

  period = 300

  evaluation_periods = 1

  threshold = 1

  comparison_operator = "GreaterThanOrEqualToThreshold"

  treat_missing_data = "notBreaching"

  alarm_actions = [
    aws_sns_topic.alerts.arn
  ]

  ok_actions = [
    aws_sns_topic.alerts.arn
  ]

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-nginx-errors"
    }
  )
}

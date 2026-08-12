resource "aws_cloudwatch_log_metric_filter" "nginx_errors" {

  name = "${local.name_prefix}-nginx-errors"

  log_group_name = var.nginx_log_group_name

  pattern = "ERROR"

  metric_transformation {

    name      = "NginxErrors"
    namespace = "${local.name_prefix}/Application"

    value = "1"
  }
}

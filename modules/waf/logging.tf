resource "aws_cloudwatch_log_group" "waf" {

  name              = "aws-waf-logs-${local.name_prefix}"
  retention_in_days = 365
  kms_key_id        = aws_kms_key.waf_logs.arn

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-waf-logs"
    }
  )
}

resource "aws_wafv2_web_acl_logging_configuration" "main" {

  resource_arn = aws_wafv2_web_acl.main.arn

  log_destination_configs = [
    aws_cloudwatch_log_group.waf.arn
  ]
}

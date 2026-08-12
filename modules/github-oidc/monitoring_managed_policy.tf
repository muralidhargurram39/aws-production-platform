resource "aws_iam_policy" "monitoring" {

  name        = "${local.name_prefix}-monitoring-policy"
  description = "CloudWatch, Logs and SNS permissions"

  policy = data.aws_iam_policy_document.monitoring.json

  tags = local.common_tags
}

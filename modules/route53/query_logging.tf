data "aws_iam_policy_document" "route53_query_logging" {
  statement {
    sid    = "AllowRoute53QueryLogging"
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "arn:aws:logs:us-east-1:*:log-group:/aws/route53/*"
    ]

    principals {
      type = "Service"

      identifiers = [
        "route53.amazonaws.com"
      ]
    }
  }
}

resource "aws_cloudwatch_log_group" "route53_query" {
  provider = aws.global

  name              = "/aws/route53/${var.domain_name}"
  retention_in_days = 365
  kms_key_id        = aws_kms_key.route53_logs.arn

  tags = local.common_tags
}

resource "aws_cloudwatch_log_resource_policy" "route53_query_logging" {
  provider = aws.global

  policy_name     = "${local.name_prefix}-route53-query-logging"
  policy_document = data.aws_iam_policy_document.route53_query_logging.json
}

resource "aws_route53_query_log" "main" {
  zone_id = aws_route53_zone.main.zone_id

  cloudwatch_log_group_arn = aws_cloudwatch_log_group.route53_query.arn

  depends_on = [
    aws_cloudwatch_log_resource_policy.route53_query_logging
  ]
}

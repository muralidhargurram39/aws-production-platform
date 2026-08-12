resource "aws_kms_key" "route53_logs" {
  provider = aws.global

  description         = "KMS key for Route 53 query logs"
  enable_key_rotation = true

  policy = data.aws_iam_policy_document.route53_logs_kms.json

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-route53-logs"
    }
  )
}

resource "aws_kms_alias" "route53_logs" {
  provider = aws.global

  name          = "alias/${local.name_prefix}-route53-logs"
  target_key_id = aws_kms_key.route53_logs.key_id
}

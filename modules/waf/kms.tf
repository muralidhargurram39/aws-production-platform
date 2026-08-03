data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "waf_logs_kms" {

  statement {

    sid    = "EnableRootPermissions"
    effect = "Allow"

    principals {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
    }

    actions = [
      "kms:*"
    ]

    resources = [
      "*"
    ]
  }

  statement {

    sid    = "AllowCloudWatchLogs"
    effect = "Allow"

    principals {
      type = "Service"

      identifiers = [
        "logs.us-east-1.amazonaws.com"
      ]
    }

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
      "kms:ReEncrypt*"
    ]

    resources = [
      "*"
    ]
  }
}

resource "aws_kms_key" "waf_logs" {

  description             = "KMS key for WAF logging"
  enable_key_rotation     = true
  deletion_window_in_days = 7

  policy = data.aws_iam_policy_document.waf_logs_kms.json

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-waf-logs-kms"
    }
  )
}

resource "aws_kms_alias" "waf_logs" {

  name          = "alias/${local.name_prefix}-waf-logs"
  target_key_id = aws_kms_key.waf_logs.key_id
}

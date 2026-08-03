data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "flow_logs_kms" {

  statement {
    sid = "EnableRootPermissions"

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
    sid = "AllowCloudWatchLogs"

    effect = "Allow"

    principals {
      type = "Service"

      identifiers = [
        "logs.ap-south-2.amazonaws.com"
      ]
    }

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]

    resources = [
      "*"
    ]
  }
}

resource "aws_kms_key" "flow_logs" {

  description             = "KMS key for VPC Flow Logs CloudWatch Log Group"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  policy = data.aws_iam_policy_document.flow_logs_kms.json

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-flowlogs-kms"
    }
  )
}

resource "aws_kms_alias" "flow_logs" {

  name          = "alias/${local.name_prefix}-flowlogs"
  target_key_id = aws_kms_key.flow_logs.key_id
}

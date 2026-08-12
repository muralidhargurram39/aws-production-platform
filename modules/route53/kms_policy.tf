data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "route53_logs_kms" {

  #checkov:skip=CKV_AWS_109:KMS key policy intentionally grants the owning account root full key administration permissions.
  #checkov:skip=CKV_AWS_111:KMS key policy intentionally grants the owning account root full key administration permissions.
  #checkov:skip=CKV_AWS_356:KMS key policy uses Resource "*" because KMS key-policy statements are scoped to the key policy itself.

  statement {
    sid    = "EnableAccountRootPermissions"
    effect = "Allow"

    principals {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
    }

    actions   = ["kms:*"]
    resources = ["*"]
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
      "kms:Decrypt",
      "kms:Encrypt",
      "kms:GenerateDataKey",
      "kms:ReEncrypt*"
    ]

    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "kms:ViaService"

      values = [
        "logs.us-east-1.amazonaws.com"
      ]
    }
  }
}

data "aws_iam_policy_document" "route53_dnssec_kms" {

  #checkov:skip=CKV_AWS_109:KMS key policy intentionally grants the owning account root full key administration permissions.
  #checkov:skip=CKV_AWS_111:KMS key policy intentionally grants the owning account root full key administration permissions.
  #checkov:skip=CKV_AWS_356:KMS key policy uses Resource "*" because KMS key-policy statements are scoped to the key policy itself.

  statement {
    sid    = "EnableAccountRootPermissions"
    effect = "Allow"

    principals {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
    }

    actions   = ["kms:*"]
    resources = ["*"]
  }

  statement {
    sid    = "AllowRoute53DNSSECService"
    effect = "Allow"

    principals {
      type = "Service"

      identifiers = [
        "dnssec-route53.amazonaws.com"
      ]
    }

    actions = [
      "kms:DescribeKey",
      "kms:GetPublicKey",
      "kms:Sign"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "AllowRoute53DNSSECCreateGrant"
    effect = "Allow"

    principals {
      type = "Service"

      identifiers = [
        "dnssec-route53.amazonaws.com"
      ]
    }

    actions = [
      "kms:CreateGrant"
    ]

    resources = ["*"]

    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"

      values = ["true"]
    }
  }
}

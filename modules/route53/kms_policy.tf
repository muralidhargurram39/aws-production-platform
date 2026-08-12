data "aws_caller_identity" "current" {}

#
# KMS key used to encrypt Route 53 query logs.
#
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

#
# KMS key used by Route 53 DNSSEC.
#
data "aws_iam_policy_document" "route53_dnssec_kms" {

  #checkov:skip=CKV_AWS_109:KMS key policy intentionally grants the owning account root full key administration permissions.
  #checkov:skip=CKV_AWS_111:KMS key policy intentionally grants the owning account root full key administration permissions.
  #checkov:skip=CKV_AWS_356:KMS key policy uses Resource "*" because KMS key-policy statements are scoped to the key policy itself.

  #
  # Account root retains full key administration.
  #
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

  #
  # Route 53 DNSSEC service must be able to inspect the public key
  # and perform DNSSEC signing operations.
  #
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

  #
  # Route 53 DNSSEC requires a grant so the AWS service can use the key
  # on behalf of the hosted zone.
  #
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

      values = [
        "true"
      ]
    }
  }
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "sns_kms" {

  #checkov:skip=CKV_AWS_109:KMS key policy uses Resource "*" by design; access is constrained by explicit service principals and conditions
  #checkov:skip=CKV_AWS_111:KMS key policy uses Resource "*" by design; access is constrained by explicit service principals and conditions
  #checkov:skip=CKV_AWS_356:KMS key policy uses Resource "*" by design; the policy is attached directly to this KMS key

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

    sid    = "AllowCloudTrail"
    effect = "Allow"

    principals {
      type = "Service"

      identifiers = [
        "cloudtrail.amazonaws.com"
      ]
    }

    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey*"
    ]

    resources = [
      "*"
    ]

    condition {

      test     = "StringEquals"
      variable = "aws:SourceAccount"

      values = [
        data.aws_caller_identity.current.account_id
      ]
    }
  }
}

resource "aws_kms_key" "sns" {

  description             = "KMS key for SNS topic encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  policy = data.aws_iam_policy_document.sns_kms.json

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-sns-kms"
    }
  )
}

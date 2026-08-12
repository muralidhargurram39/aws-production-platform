data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "backup_kms" {

  #checkov:skip=CKV_AWS_109:KMS key policy intentionally grants the owning account root full key administration permissions.
  #checkov:skip=CKV_AWS_111:KMS key policy intentionally grants the owning account root full key administration permissions.
  #checkov:skip=CKV_AWS_356:KMS key policy uses Resource "*" because KMS key-policy statements are scoped to the key policy itself.

  statement {
    sid    = "EnableRootAccountPermissions"
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
    sid    = "AllowAWSBackupService"
    effect = "Allow"

    principals {
      type = "Service"

      identifiers = [
        "backup.amazonaws.com"
      ]
    }

    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:GenerateDataKey",
      "kms:ReEncryptFrom",
      "kms:ReEncryptTo"
    ]

    resources = ["*"]
  }
}


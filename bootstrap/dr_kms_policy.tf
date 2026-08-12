data "aws_iam_policy_document" "terraform_backend_dr_kms" {

  # The account-principal statement is required to preserve administrative
  # control of the KMS key and to allow IAM policies in this account to
  # delegate permissions to the key.
  #
  # AWS KMS documents this as the standard account-level key-policy pattern.
  #
  #checkov:skip=CKV_AWS_109:Account-level KMS key administration intentionally permits full KMS permissions to preserve key manageability.
  #checkov:skip=CKV_AWS_111:Account-level KMS key administration intentionally uses kms:* as the KMS account principal statement.
  #checkov:skip=CKV_AWS_356:KMS key policy Resource=* refers to this KMS key and is required by the KMS key-policy model.  

  statement {
    sid    = "EnableAccountPermissions"
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
    sid    = "AllowS3ReplicationRole"
    effect = "Allow"

    principals {
      type = "AWS"

      identifiers = [
        aws_iam_role.terraform_state_replication.arn
      ]
    }

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncryptFrom",
      "kms:ReEncryptTo",
      "kms:GenerateDataKey",
      "kms:GenerateDataKeyWithoutPlaintext",
      "kms:DescribeKey"
    ]

    resources = ["*"]
  }
}


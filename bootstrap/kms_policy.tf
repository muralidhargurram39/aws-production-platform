data "aws_iam_policy_document" "terraform_backend_kms" {

  # The KMS root statement intentionally grants full key administration to the
  # account root principal. AWS requires an administratively capable principal
  # to remain in the key policy so the policy can be managed in the future.
  #
  #checkov:skip=CKV_AWS_109:KMS key policy root administration must retain full key permissions
  #checkov:skip=CKV_AWS_111:KMS key policy root administration intentionally uses kms:* for key management
  #checkov:skip=CKV_AWS_356:KMS key policies use Resource=* for key-policy administration

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
    sid    = "AllowS3ReplicationRole"
    effect = "Allow"

    principals {
      type = "AWS"

      identifiers = [
        aws_iam_role.terraform_state_replication.arn
      ]
    }

    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:ReEncryptFrom"
    ]

    resources = ["*"]
  }
}

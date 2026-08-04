data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "terraform_backend_kms" {

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
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:GenerateDataKey",
      "kms:DescribeKey"
    ]

    resources = [
      "*"
    ]
  }
}

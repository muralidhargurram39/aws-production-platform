data "aws_iam_policy_document" "backup" {

  statement {

    sid    = "Backup"
    effect = "Allow"

    actions = [
      "backup:*"
    ]

    resources = ["*"]
  }
}

data "aws_iam_policy_document" "governance" {

  statement {

    sid    = "Governance"
    effect = "Allow"

    actions = [
      "config:*",
      "access-analyzer:*"
    ]

    resources = ["*"]
  }
}

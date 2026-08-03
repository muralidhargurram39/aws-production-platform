data "aws_iam_policy_document" "monitoring" {

  statement {

    sid    = "Monitoring"
    effect = "Allow"

    actions = [
      "cloudwatch:*",
      "logs:*",
      "sns:*"
    ]

    resources = ["*"]
  }
}

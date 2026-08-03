data "aws_iam_policy_document" "security" {

  statement {

    sid    = "Security"
    effect = "Allow"

    actions = [
      "kms:*",
      "wafv2:*",
      "guardduty:*",
      "securityhub:*"
    ]

    resources = ["*"]
  }
}

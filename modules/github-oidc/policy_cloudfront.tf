data "aws_iam_policy_document" "cloudfront" {

  statement {

    sid    = "CDN"
    effect = "Allow"

    actions = [
      "cloudfront:*"
    ]

    resources = ["*"]
  }
}

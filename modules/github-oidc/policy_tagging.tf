data "aws_iam_policy_document" "tagging" {

  statement {

    sid    = "Tagging"
    effect = "Allow"

    actions = [
      "tag:GetResources",
      "tag:TagResources",
      "tag:UntagResources"
    ]

    resources = ["*"]
  }
}

data "aws_iam_policy_document" "networking" {

  statement {

    sid    = "Networking"
    effect = "Allow"

    actions = [
      "ec2:*",
      "elasticloadbalancing:*",
      "autoscaling:*"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "identity" {

  name        = "${local.name_prefix}-identity-policy"
  description = "IAM permissions"

  policy = data.aws_iam_policy_document.identity.json

  tags = local.common_tags
}

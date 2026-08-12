resource "aws_iam_policy" "security" {

  name        = "${local.name_prefix}-security-policy"
  description = "Security service permissions"

  policy = data.aws_iam_policy_document.security.json

  tags = local.common_tags
}

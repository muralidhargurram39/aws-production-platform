resource "aws_iam_policy" "networking" {

  name        = "${local.name_prefix}-networking-policy"
  description = "Networking permissions"

  policy = data.aws_iam_policy_document.networking.json

  tags = local.common_tags
}

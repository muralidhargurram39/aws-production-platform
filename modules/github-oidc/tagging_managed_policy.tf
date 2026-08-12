resource "aws_iam_policy" "tagging" {

  name        = "${local.name_prefix}-tagging-policy"
  description = "AWS tagging permissions"

  policy = data.aws_iam_policy_document.tagging.json

  tags = local.common_tags
}

resource "aws_iam_policy" "cloudfront" {

  name        = "${local.name_prefix}-cloudfront-policy"
  description = "CloudFront permissions"

  policy = data.aws_iam_policy_document.cloudfront.json

  tags = local.common_tags
}

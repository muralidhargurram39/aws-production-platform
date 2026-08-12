resource "aws_iam_policy" "governance" {

  name        = "${local.name_prefix}-governance-policy"
  description = "AWS Config and Access Analyzer permissions"

  policy = data.aws_iam_policy_document.governance.json

  tags = local.common_tags
}

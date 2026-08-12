resource "aws_iam_policy" "backend" {

  name        = "${local.name_prefix}-backend-policy"
  description = "Terraform backend permissions"

  policy = data.aws_iam_policy_document.backend.json

  tags = local.common_tags
}

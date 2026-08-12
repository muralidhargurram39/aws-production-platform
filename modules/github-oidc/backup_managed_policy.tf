resource "aws_iam_policy" "backup" {

  name        = "${local.name_prefix}-backup-policy"
  description = "AWS Backup permissions"

  policy = data.aws_iam_policy_document.backup.json

  tags = local.common_tags
}

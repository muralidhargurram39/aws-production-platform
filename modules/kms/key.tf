resource "aws_kms_key" "main" {

  description = "Customer managed key for platform encryption"

  enable_key_rotation = true

  deletion_window_in_days = 30

  policy = data.aws_iam_policy_document.kms.json

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-kms"
    }
  )
}

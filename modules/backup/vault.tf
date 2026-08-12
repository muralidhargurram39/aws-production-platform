resource "aws_backup_vault" "main" {
  name          = "${local.name_prefix}-backup-vault"
  kms_key_arn   = aws_kms_key.backup.arn
  force_destroy = var.force_destroy

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-backup-vault"
    }
  )
}

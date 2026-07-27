resource "aws_backup_vault" "main" {
  name = "${local.name_prefix}-backup-vault"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-backup-vault"
    }
  )
}

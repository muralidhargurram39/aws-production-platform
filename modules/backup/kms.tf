resource "aws_kms_key" "backup" {

  description             = "KMS key for AWS Backup Vault"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-backup-kms"
    }
  )
}

resource "aws_kms_alias" "backup" {

  name          = "alias/${local.name_prefix}-backup"
  target_key_id = aws_kms_key.backup.key_id
}

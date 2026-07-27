resource "aws_backup_plan" "main" {
  name = "${local.name_prefix}-backup-plan"

  rule {
    rule_name         = "daily-backup"
    target_vault_name = aws_backup_vault.main.name

    schedule = "cron(0 2 * * ? *)"

    lifecycle {
      delete_after = 30
    }
  }

  rule {
    rule_name         = "weekly-backup"
    target_vault_name = aws_backup_vault.main.name

    schedule = "cron(0 3 ? * SUN *)"

    lifecycle {
      delete_after = 90
    }
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-backup-plan"
    }
  )
}

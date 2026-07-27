output "backup_vault_name" {
  description = "Backup vault name."

  value = aws_backup_vault.main.name
}

output "backup_vault_arn" {
  description = "Backup vault ARN."

  value = aws_backup_vault.main.arn
}

output "backup_role_arn" {
  description = "AWS Backup IAM role ARN."

  value = aws_iam_role.backup.arn
}

output "backup_role_name" {
  description = "AWS Backup IAM role name."

  value = aws_iam_role.backup.name
}

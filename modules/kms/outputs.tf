output "key_id" {
  description = "KMS Key ID"
  value       = aws_kms_key.main.key_id
}

output "key_arn" {
  description = "KMS Key ARN"
  value       = aws_kms_key.main.arn
}

output "alias_name" {
  description = "KMS Alias"
  value       = aws_kms_alias.main.name
}

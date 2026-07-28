output "config_bucket_name" {
  value = aws_s3_bucket.config.bucket
}

output "config_bucket_arn" {
  value = aws_s3_bucket.config.arn
}

output "config_role_arn" {
  value = aws_iam_role.config.arn
}

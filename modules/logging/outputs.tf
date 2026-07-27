output "bucket_name" {
  description = "Logging bucket name"
  value       = aws_s3_bucket.logs.bucket
}

output "bucket_arn" {
  description = "Logging bucket ARN"
  value       = aws_s3_bucket.logs.arn
}

output "bucket_domain_name" {
  description = "Logging bucket domain name"
  value       = aws_s3_bucket.logs.bucket_domain_name
}

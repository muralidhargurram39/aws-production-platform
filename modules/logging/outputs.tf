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

output "logs_bucket_arn" {
  description = "ARN of the logging bucket"
  value       = aws_s3_bucket.logs.arn
}

output "logs_bucket_name" {
  description = "Name of the logging bucket"
  value       = aws_s3_bucket.logs.bucket
}

output "cloudfront_logs_bucket_domain_name" {
  description = "CloudFront logs bucket domain name"
  value       = aws_s3_bucket.cloudfront_logs.bucket_domain_name
}

output "cloudfront_logs_bucket_name" {
  description = "CloudFront logs bucket name"
  value       = aws_s3_bucket.cloudfront_logs.bucket
}

output "cloudfront_logs_bucket_arn" {
  description = "CloudFront logs bucket ARN"
  value       = aws_s3_bucket.cloudfront_logs.arn
}

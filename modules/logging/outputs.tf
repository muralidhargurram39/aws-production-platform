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

output "access_logs_bucket_name" {
  description = "S3 bucket receiving S3 server access logs"
  value       = aws_s3_bucket.access_logs.bucket
}

output "access_logs_bucket_arn" {
  description = "ARN of the S3 server access log bucket"
  value       = aws_s3_bucket.access_logs.arn
}

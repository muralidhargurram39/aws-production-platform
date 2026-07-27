output "distribution_id" {
  value = aws_cloudfront_distribution.main.id
}

output "distribution_domain_name" {
  value = aws_cloudfront_distribution.main.domain_name
}

output "distribution_arn" {
  description = "CloudFront distribution ARN"
  value       = aws_cloudfront_distribution.main.arn
}

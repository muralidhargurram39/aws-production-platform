output "certificate_arn" {
  description = "ACM Certificate ARN"
  value       = aws_acm_certificate.main.arn
}

output "domain_validation_options" {
  description = "DNS validation records"
  value       = aws_acm_certificate.main.domain_validation_options
}

output "certificate_status" {
  description = "Certificate status"
  value       = aws_acm_certificate.main.status
}

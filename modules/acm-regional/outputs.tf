output "certificate_arn" {
  description = "Validated ACM certificate ARN"
  value       = aws_acm_certificate_validation.main.certificate_arn
}

output "domain_validation_options" {
  description = "DNS validation records"
  value       = aws_acm_certificate.main.domain_validation_options
}

output "certificate_status" {
  description = "Certificate status"
  value       = aws_acm_certificate.main.status
}

output "certificate_domain_name" {
  description = "Primary ACM certificate domain"
  value       = aws_acm_certificate.main.domain_name
}

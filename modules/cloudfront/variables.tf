variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "origin_domain_name" {
  description = "ALB DNS name"
  type        = string
}

variable "web_acl_id" {
  description = "Optional WAF Web ACL ARN"
  type        = string
  default     = null
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "logging_bucket" {
  description = "CloudFront logging bucket domain name"
  type        = string
}

variable "logging_prefix" {
  description = "CloudFront log prefix"
  type        = string
  default     = "cloudfront/"
}

variable "aliases" {
  description = "Alternate domain names (CNAMEs)"
  type        = list(string)
  default     = []
}

variable "acm_certificate_arn" {
  description = "ACM certificate ARN for CloudFront"
  type        = string
  default     = null
}

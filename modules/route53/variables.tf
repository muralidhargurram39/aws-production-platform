variable "domain_name" {
  description = "Public domain name"
  type        = string
}

variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "cloudfront_domain_name" {
  description = "CloudFront distribution domain name"
  type        = string
  default     = null
}

variable "cloudfront_hosted_zone_id" {
  description = "CloudFront hosted zone ID"
  type        = string
  default     = null
}

variable "alb_dns_name" {
  description = "Application Load Balancer DNS name"
  type        = string
  default     = null
}

variable "alb_zone_id" {
  description = "Application Load Balancer Hosted Zone ID"
  type        = string
  default     = null
}

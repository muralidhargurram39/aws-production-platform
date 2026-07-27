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

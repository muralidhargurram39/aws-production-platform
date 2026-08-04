variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "domain_name" {
  description = "Primary domain name"
  type        = string
}

variable "hosted_zone_id" {
  description = "Route53 Hosted Zone ID used for DNS validation"
  type        = string
}

variable "subject_alternative_names" {
  description = "Additional DNS names"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}

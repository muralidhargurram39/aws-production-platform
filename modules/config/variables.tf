variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "force_destroy" {
  description = "Force delete non-empty bucket"
  type        = bool
  default     = false
}

variable "kms_key_arn" {
  description = "KMS key ARN for S3 encryption"
  type        = string
}

variable "access_log_bucket_name" {
  description = "S3 bucket receiving server access logs"
  type        = string
}

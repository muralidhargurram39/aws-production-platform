variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "account_id" {
  type = string
}

variable "source_bucket_arn" {
  type = string
}

variable "source_bucket_name" {
  type = string
}

variable "kms_key_arn" {
  description = "KMS key ARN for the DR bucket"
  type        = string
}
variable "source_kms_key_arn" {
  description = "KMS key ARN used by the source bucket"
  type        = string
}

variable "force_destroy" {
  description = "Force delete non-empty bucket"
  type        = bool
  default     = false
}


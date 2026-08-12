variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "account_id" {
  type = string
}

variable "replication_buckets" {
  description = "S3 buckets to replicate to the DR region"

  type = map(object({
    bucket_name = string
    bucket_arn  = string
    kms_key_arn = string
  }))
}

variable "kms_key_arn" {
  description = "KMS key ARN used to encrypt DR replica buckets"
  type        = string
}

variable "force_destroy" {
  description = "Force delete non-empty bucket"
  type        = bool
  default     = false
}

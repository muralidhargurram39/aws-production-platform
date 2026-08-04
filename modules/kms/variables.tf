variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "replication_role_arn" {
  description = "IAM role allowed to use this KMS key for S3 replication"
  type        = string
  default     = null
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
}

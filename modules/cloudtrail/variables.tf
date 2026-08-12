# tflint-ignore: terraform_unused_declarations
variable "project_name" {

  description = "Project name"

  type = string
}

variable "environment" {

  description = "Deployment environment"

  type = string
}

variable "trail_bucket_name" {

  description = "Existing S3 logging bucket"

  type = string
}

variable "kms_key_arn" {

  description = "KMS key used to encrypt CloudTrail logs"

  type = string
}

variable "sns_topic_arn" {
  description = "SNS topic ARN for CloudTrail log delivery notifications"
  type        = string
}

# tflint-ignore: terraform_unused_declarations
variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}

variable "kms_key_arn" {
  description = "KMS key ARN for bucket encryption"
  type        = string
}

variable "enable_cloudtrail_policy" {

  description = "Attach CloudTrail bucket policy"

  type    = bool
  default = false
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "force_destroy" {
  description = "Force delete non-empty bucket"
  type        = bool
  default     = false
}

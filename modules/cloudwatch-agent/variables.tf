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

variable "kms_key_arn" {

  description = "KMS Key ARN for CloudWatch Logs"

  type = string
}

variable "github_owner" {
  description = "GitHub username or organization"
  type        = string
}

variable "github_repository" {
  description = "GitHub repository name"
  type        = string
}

variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "backend_bucket_name" {
  description = "Terraform backend S3 bucket"
  type        = string
}

variable "backend_lock_table_name" {
  description = "Terraform backend DynamoDB table"
  type        = string
}

variable "backend_kms_key_arn" {
  description = "KMS key ARN used to encrypt the Terraform S3 backend"
  type        = string
}

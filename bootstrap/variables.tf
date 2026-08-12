variable "project_name" {
  description = "Project name used for tagging and naming resources"
  type        = string
  default     = "aws-production-platform"
}

variable "aws_region" {
  description = "AWS Region for bootstrap resources"
  type        = string
  default     = "ap-south-2"
}

variable "state_bucket_name" {
  description = "S3 bucket name for Terraform remote state"
  type        = string

  default = "aws-production-platform-tf-state-2026"
}

variable "lock_table_name" {
  description = "DynamoDB table used for Terraform state locking"
  type        = string

  default = "aws-production-platform-terraform-lock"
}

variable "dr_region" {
  description = "AWS Region used for the Terraform state DR replica"
  type        = string
  default     = "ap-south-1"
}

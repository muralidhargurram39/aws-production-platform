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

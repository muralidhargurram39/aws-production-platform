variable "project_name" {
  description = "Project name."
  type        = string
}

variable "environment" {
  description = "Deployment environment."
  type        = string
}

variable "backup_tag_key" {
  description = "Tag key used to identify resources for backup."
  type        = string

  default = "Backup"
}

variable "backup_tag_value" {
  description = "Tag value used to identify resources for backup."
  type        = string

  default = "true"
}

variable "force_destroy" {
  description = "Force delete non-empty bucket"
  type        = bool
  default     = false
}

variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "application_security_group_id" {
  type = string
}

variable "instance_profile_name" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "desired_capacity" {
  type    = number
  default = 2
}

variable "min_size" {
  type    = number
  default = 2
}

variable "max_size" {
  type    = number
  default = 4
}

variable "root_volume_size" {
  type    = number
  default = 20
}

variable "target_group_arns" {
  description = "Target Groups for the Auto Scaling Group"
  type        = list(string)
  default     = []
}

variable "ami_id" {
  description = "Optional AMI ID. If null, the latest Amazon Linux 2023 AMI is used."
  type        = string
  default     = null
}

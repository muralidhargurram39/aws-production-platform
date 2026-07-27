variable "project_name" {
  description = "Project name used for naming resources."
  type        = string
}

variable "environment" {
  description = "Deployment environment."
  type        = string
}

variable "autoscaling_group_name" {
  description = "Name of the Auto Scaling Group to monitor."
  type        = string
}

variable "load_balancer_arn_suffix" {
  description = "ARN suffix of the Application Load Balancer."
  type        = string
}

variable "target_group_arn_suffix" {
  description = "ARN suffix of the Target Group."
  type        = string
}

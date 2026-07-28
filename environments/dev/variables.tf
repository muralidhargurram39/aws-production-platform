variable "aws_region" {
  type    = string
  default = "ap-south-2"
}

variable "project_name" {
  type    = string
  default = "aws-production-platform"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "ami_id" {
  description = "Optional AMI ID override for EC2 instances."
  type        = string
  default     = null
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDRs for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDRs for private subnets"
  type        = list(string)
}

variable "database_subnet_cidrs" {
  description = "CIDRs for database subnets"
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Whether to create NAT Gateways"
  type        = bool
}

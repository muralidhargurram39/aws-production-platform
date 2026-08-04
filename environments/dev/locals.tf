locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

locals {

  replication_role_arn = "arn:aws:iam::626311400372:role/aws-production-platform-dev-s3-replication-role"

}

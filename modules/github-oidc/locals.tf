locals {

  #
  # Naming
  #
  name_prefix = "${var.project_name}-${var.environment}"

  #
  # Common Tags
  #
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }

  #
  # IAM ARNs
  #
  iam_role_arn = "arn:aws:iam::*:role/${var.project_name}-*"

  iam_policy_arn = "arn:aws:iam::*:policy/${var.project_name}-*"

  instance_profile_arn = "arn:aws:iam::*:instance-profile/${var.project_name}-*"

  oidc_provider_arn = "arn:aws:iam::*:oidc-provider/token.actions.githubusercontent.com"

}

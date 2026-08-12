data "aws_caller_identity" "current" {}

resource "aws_kms_key" "terraform_backend_dr" {
  provider = aws.dr

  description             = "KMS key for Terraform backend DR replica"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  policy = data.aws_iam_policy_document.terraform_backend_dr_kms.json

  tags = {
    Name        = "${var.project_name}-terraform-backend-dr-kms"
    Project     = var.project_name
    Environment = "bootstrap-dr"
    ManagedBy   = "Terraform"
  }
}

resource "aws_kms_alias" "terraform_backend_dr" {
  provider = aws.dr

  name          = "alias/${var.project_name}-terraform-backend-dr"
  target_key_id = aws_kms_key.terraform_backend_dr.key_id
}

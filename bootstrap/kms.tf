resource "aws_kms_key" "terraform_backend" {

  description             = "KMS key for Terraform backend"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  policy = data.aws_iam_policy_document.terraform_backend_kms.json

  tags = {
    Name        = "${var.project_name}-terraform-backend-kms"
    Project     = var.project_name
    Environment = "bootstrap"
    ManagedBy   = "Terraform"
  }
}

resource "aws_kms_alias" "terraform_backend" {

  name          = "alias/${var.project_name}-terraform-backend"
  target_key_id = aws_kms_key.terraform_backend.key_id
}

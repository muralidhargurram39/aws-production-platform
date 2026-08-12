output "terraform_state_bucket" {

  description = "Terraform state bucket"

  value = aws_s3_bucket.terraform_state.bucket

}

output "terraform_lock_table" {

  description = "Terraform lock table"

  value = aws_dynamodb_table.terraform_lock.name

}

output "aws_region" {

  description = "AWS Region"

  value = var.aws_region

}

output "project_name" {

  description = "Project Name"

  value = var.project_name

}

output "terraform_state_dr_bucket" {
  description = "Terraform state DR replica bucket"

  value = aws_s3_bucket.terraform_state_dr.bucket
}

output "terraform_state_dr_region" {
  description = "Terraform state DR region"

  value = var.dr_region
}

output "terraform_state_dr_kms_key_arn" {
  description = "Terraform state DR KMS key ARN"

  value = aws_kms_key.terraform_backend_dr.arn
}

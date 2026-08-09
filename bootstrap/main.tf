resource "aws_s3_bucket" "terraform_state" {
  bucket = var.state_bucket_name

  force_destroy = false
}

resource "aws_s3_bucket_versioning" "versioning" {

  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }

}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {

  bucket = aws_s3_bucket.terraform_state.id

  rule {

    apply_server_side_encryption_by_default {

      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.terraform_backend.arn

    }

    bucket_key_enabled = true

  }

}

resource "aws_s3_bucket_public_access_block" "block" {

  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true

}

resource "aws_dynamodb_table" "terraform_lock" {

  name         = var.lock_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_key.terraform_backend.arn
  }

  point_in_time_recovery {
    enabled = true
  }
}

module "github_oidc" {
  source = "../modules/github-oidc"

  github_owner      = "muralidhargurram39"
  github_repository = "aws-production-platform"

  project_name            = var.project_name
  environment             = "dev"
  backend_bucket_name     = var.state_bucket_name
  backend_lock_table_name = var.lock_table_name
}

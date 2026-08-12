resource "aws_s3_bucket" "terraform_state_dr" {
  #checkov:skip=CKV2_AWS_62:S3 event notifications are intentionally not configured because the Terraform state DR bucket has no event-driven consumer.
  provider = aws.dr

  bucket = "${var.state_bucket_name}-dr"

  force_destroy = false

  tags = {
    Name        = "${var.project_name}-terraform-state-dr"
    Project     = var.project_name
    Environment = "bootstrap-dr"
    ManagedBy   = "Terraform"
  }
}

resource "aws_s3_bucket_versioning" "terraform_state_dr" {
  provider = aws.dr

  bucket = aws_s3_bucket.terraform_state_dr.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_dr" {
  provider = aws.dr

  bucket = aws_s3_bucket.terraform_state_dr.id

  rule {
    bucket_key_enabled = true

    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.terraform_backend_dr.arn
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "terraform_state_dr" {
  provider = aws.dr

  bucket = aws_s3_bucket.terraform_state_dr.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state_dr" {
  provider = aws.dr

  bucket = aws_s3_bucket.terraform_state_dr.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "terraform_state_dr" {
  provider = aws.dr

  bucket = aws_s3_bucket.terraform_state_dr.id

  rule {
    id     = "terraform-state-dr"
    status = "Enabled"

    filter {}

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }

    noncurrent_version_expiration {
      noncurrent_days = 90
    }
  }
}

resource "aws_s3_bucket" "logs" {

  bucket = "${local.name_prefix}-${data.aws_caller_identity.current.account_id}-logs"

  force_destroy = true

  tags = local.common_tags
}

resource "aws_s3_bucket_versioning" "logs" {

  bucket = aws_s3_bucket.logs.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "logs" {

  bucket = aws_s3_bucket.logs.id

  rule {

    apply_server_side_encryption_by_default {

      sse_algorithm     = "aws:kms"
      kms_master_key_id = var.kms_key_arn
    }

    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "logs" {

  bucket = aws_s3_bucket.logs.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "logs" {

  bucket = aws_s3_bucket.logs.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "logs" {

  bucket = aws_s3_bucket.logs.id

  rule {

    id     = "log-retention"
    status = "Enabled"

    filter {}

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }

    transition {

      days          = 90
      storage_class = "GLACIER"
    }

    expiration {
      days = 365
    }

    noncurrent_version_expiration {
      noncurrent_days = 90
    }

  }
}

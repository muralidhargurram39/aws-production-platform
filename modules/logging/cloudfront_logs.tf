resource "aws_s3_bucket" "cloudfront_logs" {

  bucket = "${local.name_prefix}-${data.aws_caller_identity.current.account_id}-cloudfront-logs"

  force_destroy = true

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-cloudfront-logs"
    }
  )
}

resource "aws_s3_bucket_versioning" "cloudfront_logs" {

  bucket = aws_s3_bucket.cloudfront_logs.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "cloudfront_logs" {

  bucket = aws_s3_bucket.cloudfront_logs.id

  rule {
    apply_server_side_encryption_by_default {

      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "cloudfront_logs" {

  bucket = aws_s3_bucket.cloudfront_logs.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "cloudfront_logs" {

  bucket = aws_s3_bucket.cloudfront_logs.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "cloudfront_logs" {

  bucket = aws_s3_bucket.cloudfront_logs.id

  rule {

    id     = "cloudfront-log-retention"
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

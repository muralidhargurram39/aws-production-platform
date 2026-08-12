resource "aws_s3_bucket" "cloudfront_logs" {
  #checkov:skip=CKV_AWS_144:Cross-region replication is configured by the disaster-recovery module, which uses this bucket as a replication source and replicates it to the DR CloudFront logs replica.
  #checkov:skip=CKV2_AWS_62:S3 event notifications are intentionally not configured because CloudFront log storage has no event-driven consumer.

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
      sse_algorithm     = "aws:kms"
      kms_master_key_id = var.kms_key_arn
    }

    bucket_key_enabled = true
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
    object_ownership = "BucketOwnerEnforced"
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

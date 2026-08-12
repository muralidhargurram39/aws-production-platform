resource "aws_s3_bucket" "replica" {
  #checkov:skip=CKV_AWS_144:This bucket is an intentional cross-region replication destination; CRR is configured on the corresponding primary-region source bucket.
  #checkov:skip=CKV2_AWS_62:S3 event notifications are intentionally not configured because DR replication destinations have no event-driven consumer.
  #checkov:skip=CKV_AWS_18:DR replication destinations are terminal recovery-storage buckets; access logging is intentionally enabled on the primary application buckets.
  #checkov:skip=CKV_AWS_145:S3 server access logs use SSE-S3 for the terminal log-delivery sink; KMS encryption is intentionally not required for this delivery bucket.
  for_each = var.replication_buckets

  provider = aws.dr

  bucket = "${var.project_name}-${var.environment}-${var.account_id}-${each.key}-dr"

  force_destroy = var.force_destroy

  tags = {
    Name = "${var.project_name}-${var.environment}-${each.key}-dr"
  }
}

resource "aws_s3_bucket_versioning" "replica" {
  for_each = var.replication_buckets

  provider = aws.dr

  bucket = aws_s3_bucket.replica[each.key].id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "replica" {
  for_each = var.replication_buckets

  provider = aws.dr

  bucket = aws_s3_bucket.replica[each.key].id

  rule {
    bucket_key_enabled = true

    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "replica" {
  for_each = var.replication_buckets

  provider = aws.dr

  bucket = aws_s3_bucket.replica[each.key].id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "replica" {
  for_each = var.replication_buckets

  provider = aws.dr

  bucket = aws_s3_bucket.replica[each.key].id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "replica" {
  for_each = var.replication_buckets

  provider = aws.dr

  bucket = aws_s3_bucket.replica[each.key].id

  rule {
    id     = "${each.key}-dr-lifecycle"
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

resource "aws_s3_bucket" "access_logs" {
  provider = aws.dr

  # Terminal access-log sink. It intentionally does not log itself.
  #checkov:skip=CKV_AWS_18:This is the terminal S3 server-access-log sink and intentionally does not log itself.
  #checkov:skip=CKV2_AWS_62:This is a terminal access-log sink with no event-driven consumer.
  #checkov:skip=CKV_AWS_144:This is the terminal DR-region S3 access-log sink; replicating the log sink itself would create an unnecessary replication chain.
  #checkov:skip=CKV_AWS_145:S3 server access logs use SSE-S3 for the terminal log-delivery sink; KMS encryption is intentionally not required for this delivery bucket.

  bucket = "${var.project_name}-${var.environment}-${var.account_id}-dr-s3-access-logs"

  force_destroy = var.force_destroy

  tags = {
    Name        = "${var.project_name}-${var.environment}-dr-s3-access-logs"
    Project     = var.project_name
    Environment = "${var.environment}-dr"
    ManagedBy   = "Terraform"
  }
}

resource "aws_s3_bucket_versioning" "access_logs" {
  provider = aws.dr

  bucket = aws_s3_bucket.access_logs.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "access_logs" {
  provider = aws.dr

  bucket = aws_s3_bucket.access_logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "access_logs" {
  provider = aws.dr

  bucket = aws_s3_bucket.access_logs.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "access_logs" {
  provider = aws.dr

  bucket = aws_s3_bucket.access_logs.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "access_logs" {
  provider = aws.dr

  bucket = aws_s3_bucket.access_logs.id

  rule {
    id     = "dr-s3-access-log-retention"
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

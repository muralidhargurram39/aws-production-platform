resource "aws_s3_bucket" "access_logs" {
  # Terminal access-log sink. It intentionally does not log itself.
  #checkov:skip=CKV_AWS_18:This is the terminal S3 server-access-log sink and intentionally does not log itself.
  #checkov:skip=CKV2_AWS_62:This is a terminal access-log sink with no event-driven consumer.
  #checkov:skip=CKV_AWS_144:This is the terminal primary-region S3 access-log sink; replicating the log sink itself would create an unnecessary replication chain.
  #checkov:skip=CKV_AWS_145:S3 server access logs use SSE-S3 for the terminal log-delivery sink; KMS encryption is intentionally not required for this delivery bucket.

  bucket = "${local.name_prefix}-${data.aws_caller_identity.current.account_id}-s3-access-logs"

  force_destroy = var.force_destroy

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-s3-access-logs"
    }
  )
}

resource "aws_s3_bucket_versioning" "access_logs" {
  bucket = aws_s3_bucket.access_logs.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "access_logs" {
  bucket = aws_s3_bucket.access_logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }

    bucket_key_enabled = false
  }
}

resource "aws_s3_bucket_public_access_block" "access_logs" {
  bucket = aws_s3_bucket.access_logs.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "access_logs" {
  bucket = aws_s3_bucket.access_logs.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "access_logs" {
  bucket = aws_s3_bucket.access_logs.id

  rule {
    id     = "s3-access-log-retention"
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

data "aws_iam_policy_document" "access_logs" {
  statement {
    sid    = "AllowS3ServerAccessLogDelivery"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["logging.s3.amazonaws.com"]
    }

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "${aws_s3_bucket.access_logs.arn}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"

      values = [
        data.aws_caller_identity.current.account_id,
      ]
    }

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"

      values = [
        "arn:aws:s3:::${local.name_prefix}-*",
      ]
    }
  }
}

resource "aws_s3_bucket_policy" "access_logs" {
  bucket = aws_s3_bucket.access_logs.id
  policy = data.aws_iam_policy_document.access_logs.json
}

resource "aws_s3_bucket_logging" "logs" {
  bucket = aws_s3_bucket.logs.id

  target_bucket = aws_s3_bucket.access_logs.id
  target_prefix = "logs/"
}

resource "aws_s3_bucket_logging" "cloudfront_logs" {
  bucket = aws_s3_bucket.cloudfront_logs.id

  target_bucket = aws_s3_bucket.access_logs.id
  target_prefix = "cloudfront/"
}

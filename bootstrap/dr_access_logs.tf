resource "aws_s3_bucket" "access_logs_dr" {
  provider = aws.dr

  # Terminal access-log sink.
  #checkov:skip=CKV_AWS_18:This is the terminal S3 server-access-log sink and intentionally does not log itself.
  #checkov:skip=CKV2_AWS_62:This is a terminal access-log sink with no event-driven consumer.
  #checkov:skip=CKV_AWS_144:This is the terminal bootstrap DR-region S3 access-log sink; replicating the log sink itself would create an unnecessary replication chain.
  #checkov:skip=CKV_AWS_145:S3 server access logs use SSE-S3 for the terminal log-delivery sink; KMS encryption is intentionally not required for this delivery bucket.

  bucket = "${var.state_bucket_name}-dr-access-logs"

  force_destroy = false

  tags = {
    Name        = "${var.project_name}-terraform-state-dr-access-logs"
    Project     = var.project_name
    Environment = "bootstrap-dr"
    ManagedBy   = "Terraform"
  }
}

resource "aws_s3_bucket_versioning" "access_logs_dr" {
  provider = aws.dr

  bucket = aws_s3_bucket.access_logs_dr.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "access_logs_dr" {
  provider = aws.dr

  bucket = aws_s3_bucket.access_logs_dr.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "access_logs_dr" {
  provider = aws.dr

  bucket = aws_s3_bucket.access_logs_dr.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "access_logs_dr" {
  provider = aws.dr

  bucket = aws_s3_bucket.access_logs_dr.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "access_logs_dr" {
  provider = aws.dr

  bucket = aws_s3_bucket.access_logs_dr.id

  rule {
    id     = "bootstrap-dr-access-log-retention"
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
      noncurrent_days = 365
    }
  }
}

data "aws_iam_policy_document" "access_logs_dr" {
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
      "${aws_s3_bucket.access_logs_dr.arn}/*",
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
        "arn:aws:s3:::${var.state_bucket_name}-dr",
      ]
    }
  }
}

resource "aws_s3_bucket_policy" "access_logs_dr" {
  provider = aws.dr

  bucket = aws_s3_bucket.access_logs_dr.id
  policy = data.aws_iam_policy_document.access_logs_dr.json
}

resource "aws_s3_bucket_logging" "terraform_state_dr" {
  provider = aws.dr

  bucket = aws_s3_bucket.terraform_state_dr.id

  target_bucket = aws_s3_bucket.access_logs_dr.id
  target_prefix = "terraform-state-dr/"
}

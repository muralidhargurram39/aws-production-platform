resource "aws_s3_bucket" "logs_replica" {
  provider = aws.dr

  bucket = "${var.project_name}-${var.environment}-${var.account_id}-logs-dr"

  tags = {
    Name = "${var.project_name}-${var.environment}-logs-dr"
  }
  force_destroy = var.force_destroy
}

resource "aws_s3_bucket_versioning" "logs_replica" {
  provider = aws.dr

  bucket = aws_s3_bucket.logs_replica.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "logs_replica" {

  provider = aws.dr

  bucket = aws_s3_bucket.logs_replica.id

  rule {

    bucket_key_enabled = true

    apply_server_side_encryption_by_default {

      kms_master_key_id = var.kms_key_arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "logs_replica" {
  provider = aws.dr

  bucket = aws_s3_bucket.logs_replica.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "logs_replica" {
  provider = aws.dr

  bucket = aws_s3_bucket.logs_replica.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

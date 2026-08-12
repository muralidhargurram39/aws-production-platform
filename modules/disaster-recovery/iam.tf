resource "aws_iam_role" "replication" {
  name = "${var.project_name}-${var.environment}-s3-replication-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "AllowS3ReplicationService"
        Effect = "Allow"

        Principal = {
          Service = "s3.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

data "aws_iam_policy_document" "replication" {
  statement {
    sid    = "ReadSourceBuckets"
    effect = "Allow"

    actions = [
      "s3:GetReplicationConfiguration",
      "s3:ListBucket"
    ]

    resources = [
      for bucket in var.replication_buckets : bucket.bucket_arn
    ]
  }

  statement {
    sid    = "ReadSourceObjects"
    effect = "Allow"

    actions = [
      "s3:GetObjectVersion",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionTagging",
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectRetention",
      "s3:GetObjectLegalHold"
    ]

    resources = [
      for bucket in var.replication_buckets :
      "${bucket.bucket_arn}/*"
    ]
  }

  statement {
    sid    = "SourceKMS"
    effect = "Allow"

    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:ReEncryptFrom"
    ]

    resources = distinct([
      for bucket in var.replication_buckets : bucket.kms_key_arn
    ])
  }

  statement {
    sid    = "DestinationKMS"
    effect = "Allow"

    actions = [
      "kms:Encrypt",
      "kms:DescribeKey",
      "kms:GenerateDataKey",
      "kms:GenerateDataKeyWithoutPlaintext",
      "kms:ReEncryptTo"
    ]

    resources = [
      var.kms_key_arn
    ]
  }

  statement {
    sid    = "WriteReplicaObjects"
    effect = "Allow"

    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
      "s3:ReplicateTags",
      "s3:ObjectOwnerOverrideToBucketOwner"
    ]

    resources = [
      for bucket in aws_s3_bucket.replica :
      "${bucket.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "replication" {
  name   = "${var.project_name}-${var.environment}-s3-replication-policy"
  policy = data.aws_iam_policy_document.replication.json

  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_iam_role_policy_attachment" "replication" {
  role       = aws_iam_role.replication.name
  policy_arn = aws_iam_policy.replication.arn
}

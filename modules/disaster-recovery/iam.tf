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

resource "aws_iam_policy" "replication" {

  name = "${var.project_name}-${var.environment}-s3-replication-policy"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      #
      # ------------------------------------------------------------------
      # Read Source Bucket Configuration
      # ------------------------------------------------------------------
      #
      {
        Sid    = "ReadSourceBucket"
        Effect = "Allow"

        Action = [
          "s3:GetReplicationConfiguration",
          "s3:ListBucket"
        ]

        Resource = [
          var.source_bucket_arn
        ]
      },

      #
      # ------------------------------------------------------------------
      # Read Source Objects
      # Required for replication of versioned and KMS-encrypted objects.
      # ------------------------------------------------------------------
      #
      {
        Sid    = "ReadSourceObjects"
        Effect = "Allow"

        Action = [
          "s3:GetObjectVersion",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionTagging",
          "s3:GetObjectVersionForReplication",
          "s3:GetObjectRetention",
          "s3:GetObjectLegalHold"
        ]

        Resource = [
          "${var.source_bucket_arn}/*"
        ]
      },

      #
      # ------------------------------------------------------------------
      # Source KMS Key Permissions
      # Required to decrypt source objects.
      # ------------------------------------------------------------------
      #
      {
        Sid    = "SourceKMS"
        Effect = "Allow"

        Action = [
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:ReEncryptFrom"
        ]

        Resource = [
          var.source_kms_key_arn
        ]
      },

      #
      # ------------------------------------------------------------------
      # Destination KMS Key Permissions
      # Required to encrypt replicated objects.
      # ------------------------------------------------------------------
      #
      {
        Sid    = "DestinationKMS"
        Effect = "Allow"

        Action = [
          "kms:Encrypt",
          "kms:DescribeKey",
          "kms:GenerateDataKey",
          "kms:GenerateDataKeyWithoutPlaintext",
          "kms:ReEncryptTo"
        ]

        Resource = [
          var.kms_key_arn
        ]
      },

      #
      # ------------------------------------------------------------------
      # Write Replicated Objects
      # ------------------------------------------------------------------
      #
      {
        Sid    = "WriteReplicaObjects"
        Effect = "Allow"

        Action = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags",
          "s3:ObjectOwnerOverrideToBucketOwner"
        ]

        Resource = [
          "${aws_s3_bucket.logs_replica.arn}/*"
        ]
      }
    ]
  })

  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_iam_role_policy_attachment" "replication" {

  role = aws_iam_role.replication.name

  policy_arn = aws_iam_policy.replication.arn
}

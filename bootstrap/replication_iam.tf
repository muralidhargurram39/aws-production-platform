resource "aws_iam_role" "terraform_state_replication" {
  name = "${var.project_name}-terraform-state-replication"

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

resource "aws_iam_policy" "terraform_state_replication" {
  name = "${var.project_name}-terraform-state-replication"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "ReadSourceBucket"
        Effect = "Allow"

        Action = [
          "s3:GetReplicationConfiguration",
          "s3:ListBucket"
        ]

        Resource = [
          aws_s3_bucket.terraform_state.arn
        ]
      },

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
          "${aws_s3_bucket.terraform_state.arn}/*"
        ]
      },

      {
        Sid    = "DecryptSourceObjects"
        Effect = "Allow"

        Action = [
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:ReEncryptFrom"
        ]

        Resource = [
          aws_kms_key.terraform_backend.arn
        ]
      },

      {
        Sid    = "EncryptDestinationObjects"
        Effect = "Allow"

        Action = [
          "kms:Encrypt",
          "kms:DescribeKey",
          "kms:GenerateDataKey",
          "kms:GenerateDataKeyWithoutPlaintext",
          "kms:ReEncryptTo"
        ]

        Resource = [
          aws_kms_key.terraform_backend_dr.arn
        ]
      },

      {
        Sid    = "ReplicateObjects"
        Effect = "Allow"

        Action = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags",
          "s3:ObjectOwnerOverrideToBucketOwner"
        ]

        Resource = [
          "${aws_s3_bucket.terraform_state_dr.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "terraform_state_replication" {
  role = aws_iam_role.terraform_state_replication.name

  policy_arn = aws_iam_policy.terraform_state_replication.arn
}

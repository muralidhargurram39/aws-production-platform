resource "aws_iam_role" "replication" {
  name = "${var.project_name}-${var.environment}-s3-replication-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
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

      {
        Effect = "Allow"

        Action = [
          "s3:GetReplicationConfiguration",
          "s3:ListBucket"
        ]

        Resource = [
          var.source_bucket_arn
        ]
      },

      {
        Effect = "Allow"

        Action = [
          "s3:GetObjectVersion",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionTagging"
        ]

        Resource = [
          "${var.source_bucket_arn}/*"
        ]
      },

      {
        Effect = "Allow"

        Action = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags"
        ]

        Resource = [
          "${aws_s3_bucket.logs_replica.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "replication" {
  role       = aws_iam_role.replication.name
  policy_arn = aws_iam_policy.replication.arn
}

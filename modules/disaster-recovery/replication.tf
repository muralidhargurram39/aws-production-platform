resource "aws_s3_bucket_replication_configuration" "logs" {

  bucket = var.source_bucket_name
  role   = aws_iam_role.replication.arn

  depends_on = [
    aws_iam_role_policy_attachment.replication,
    aws_s3_bucket_versioning.logs_replica
  ]

  rule {

    id     = "replicate-all-objects"
    status = "Enabled"

    filter {}

    delete_marker_replication {
      status = "Enabled"
    }

    destination {

      bucket        = aws_s3_bucket.logs_replica.arn
      storage_class = "STANDARD"
    }
  }
}

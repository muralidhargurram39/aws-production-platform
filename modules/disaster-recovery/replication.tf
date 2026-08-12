resource "aws_s3_bucket_replication_configuration" "replication" {
  for_each = var.replication_buckets

  bucket = each.value.bucket_name
  role   = aws_iam_role.replication.arn

  depends_on = [
    aws_iam_role_policy_attachment.replication,
    aws_s3_bucket_versioning.replica
  ]

  rule {
    id     = "replicate-${each.key}"
    status = "Enabled"

    filter {}

    delete_marker_replication {
      status = "Enabled"
    }

    source_selection_criteria {
      sse_kms_encrypted_objects {
        status = "Enabled"
      }
    }

    destination {
      bucket        = aws_s3_bucket.replica[each.key].arn
      storage_class = "STANDARD"

      encryption_configuration {
        replica_kms_key_id = var.kms_key_arn
      }
    }
  }
}

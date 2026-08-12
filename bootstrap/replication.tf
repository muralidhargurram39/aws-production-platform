resource "aws_s3_bucket_replication_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  role = aws_iam_role.terraform_state_replication.arn

  depends_on = [
    aws_s3_bucket_versioning.versioning,
    aws_s3_bucket_versioning.terraform_state_dr,
    aws_iam_role_policy_attachment.terraform_state_replication
  ]

  rule {
    id     = "terraform-state-dr"
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
      bucket        = aws_s3_bucket.terraform_state_dr.arn
      storage_class = "STANDARD"

      encryption_configuration {
        replica_kms_key_id = aws_kms_key.terraform_backend_dr.arn
      }
    }
  }
}

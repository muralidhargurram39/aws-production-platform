resource "aws_s3_bucket_ownership_controls" "terraform_state" {

  bucket = aws_s3_bucket.terraform_state.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "terraform_state" {

  bucket = aws_s3_bucket.terraform_state.id

  rule {

    id     = "terraform-state"
    status = "Enabled"

    filter {}

    abort_incomplete_multipart_upload {

      days_after_initiation = 7

    }

  }

}

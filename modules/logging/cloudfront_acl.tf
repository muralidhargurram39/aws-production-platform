resource "aws_s3_bucket_acl" "cloudfront_logs" {

  depends_on = [
    aws_s3_bucket_ownership_controls.cloudfront_logs
  ]

  bucket = aws_s3_bucket.cloudfront_logs.id

  acl = "private"
}

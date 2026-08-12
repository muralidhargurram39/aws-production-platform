output "replica_bucket_names" {
  description = "Names of the DR replica buckets"

  value = {
    for key, bucket in aws_s3_bucket.replica :
    key => bucket.bucket
  }
}

output "replica_bucket_arns" {
  description = "ARNs of the DR replica buckets"

  value = {
    for key, bucket in aws_s3_bucket.replica :
    key => bucket.arn
  }
}

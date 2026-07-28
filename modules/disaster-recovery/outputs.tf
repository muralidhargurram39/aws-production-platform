output "replica_bucket_name" {
  value = aws_s3_bucket.logs_replica.bucket
}

output "replica_bucket_arn" {
  value = aws_s3_bucket.logs_replica.arn
}

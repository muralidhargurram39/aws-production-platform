output "trail_arn" {

  description = "CloudTrail ARN"

  value = aws_cloudtrail.main.arn
}

output "trail_name" {

  description = "CloudTrail name"

  value = aws_cloudtrail.main.name
}

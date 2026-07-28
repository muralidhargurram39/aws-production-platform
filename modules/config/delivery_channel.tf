resource "aws_config_delivery_channel" "main" {
  name           = "${var.project_name}-${var.environment}-delivery-channel"
  s3_bucket_name = aws_s3_bucket.config.bucket

  depends_on = [
    aws_config_configuration_recorder.main,
    aws_s3_bucket_policy.config
  ]
}

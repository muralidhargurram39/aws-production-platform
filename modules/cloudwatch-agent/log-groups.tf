resource "aws_cloudwatch_log_group" "nginx" {

  name = "/aws/ec2/nginx"

  retention_in_days = 365

  kms_key_id = var.kms_key_arn

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-nginx"
    }
  )
}

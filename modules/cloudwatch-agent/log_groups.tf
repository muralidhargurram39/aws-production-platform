resource "aws_cloudwatch_log_group" "messages" {

  name              = "/aws/ec2/messages"
  retention_in_days = 365
  kms_key_id        = var.kms_key_arn

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-messages"
    }
  )
}

resource "aws_cloudwatch_log_group" "secure" {

  name              = "/aws/ec2/secure"
  retention_in_days = 365
  kms_key_id        = var.kms_key_arn

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-secure"
    }
  )
}

resource "aws_cloudwatch_log_group" "cloud_init" {

  name              = "/aws/ec2/cloud-init"
  retention_in_days = 365
  kms_key_id        = var.kms_key_arn

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-cloud-init"
    }
  )
}

resource "aws_cloudwatch_log_group" "amazon_ssm" {

  name              = "/aws/ssm"
  retention_in_days = 365
  kms_key_id        = var.kms_key_arn

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-ssm"
    }
  )
}

resource "aws_cloudwatch_log_group" "cloudwatch_agent" {

  name              = "/aws/amazon-cloudwatch-agent"
  retention_in_days = 365
  kms_key_id        = var.kms_key_arn

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-cloudwatch-agent"
    }
  )
}

resource "aws_ssm_parameter" "cloudwatch_agent" {

  name = local.parameter_name

  type   = "SecureString"
  key_id = var.kms_key_arn

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-cloudwatch-agent-config"
    }
  )

  value = local.cloudwatch_agent_config
}

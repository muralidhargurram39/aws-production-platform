output "parameter_name" {

  description = "SSM Parameter containing CloudWatch Agent configuration"

  value = aws_ssm_parameter.cloudwatch_agent.name
}

output "association_id" {

  description = "SSM Association ID"

  value = aws_ssm_association.cloudwatch_agent.association_id
}

output "cloudwatch_agent_log_group" {

  value = aws_cloudwatch_log_group.cloudwatch_agent.name
}

output "messages_log_group" {

  value = aws_cloudwatch_log_group.messages.name
}

output "nginx_log_group_name" {
  value = aws_cloudwatch_log_group.nginx.name
}

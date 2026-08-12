resource "aws_ssm_association" "cloudwatch_agent" {

  name = "AmazonCloudWatch-ManageAgent"

  association_name = "${var.project_name}-${var.environment}-cloudwatch-agent"

  parameters = {

    action = "configure"

    mode = "ec2"

    optionalConfigurationSource = "ssm"

    optionalConfigurationLocation = aws_ssm_parameter.cloudwatch_agent.name

    optionalRestart = "yes"
  }

  targets {

    key = "tag:Project"

    values = [
      var.project_name
    ]
  }

  targets {

    key = "tag:Environment"

    values = [
      var.environment
    ]
  }
}

output "launch_template_id" {
  value = aws_launch_template.application.id
}

output "launch_template_latest_version" {
  value = aws_launch_template.application.latest_version
}

output "autoscaling_group_name" {
  value = aws_autoscaling_group.application.name
}

output "autoscaling_group_arn" {
  value = aws_autoscaling_group.application.arn
}

output "ami_id" {
  value = data.aws_ami.amazon_linux.id
}

output "ami_name" {
  value = data.aws_ami.amazon_linux.name
}

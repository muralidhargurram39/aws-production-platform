output "ssm_policy_arn" {

  description = "Amazon SSM Managed Instance Core Policy"

  value = aws_iam_role_policy_attachment.ssm.policy_arn
}

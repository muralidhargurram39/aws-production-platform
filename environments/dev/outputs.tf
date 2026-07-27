output "vpc_id" {
  value = module.network.vpc_id
}

output "public_subnet_ids" {
  value = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.network.private_subnet_ids
}

output "database_subnet_ids" {
  value = module.network.database_subnet_ids
}
output "alb_security_group_id" {
  value = module.security.alb_security_group_id
}

output "application_security_group_id" {
  value = module.security.application_security_group_id
}

output "database_security_group_id" {
  value = module.security.database_security_group_id
}

output "management_security_group_id" {
  value = module.security.management_security_group_id
}
output "ec2_role_name" {
  value = module.iam.ec2_role_name
}

output "ec2_role_arn" {
  value = module.iam.ec2_role_arn
}

output "instance_profile_name" {
  value = module.iam.instance_profile_name
}

output "instance_profile_arn" {
  value = module.iam.instance_profile_arn
}

output "launch_template_id" {
  value = module.compute.launch_template_id
}

output "launch_template_latest_version" {
  value = module.compute.launch_template_latest_version
}

output "autoscaling_group_name" {
  value = module.compute.autoscaling_group_name
}

output "autoscaling_group_arn" {
  value = module.compute.autoscaling_group_arn
}

output "ami_id" {
  value = module.compute.ami_id
}

output "ami_name" {
  value = module.compute.ami_name
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "alb_arn" {
  value = module.alb.alb_arn
}

output "target_group_arn" {
  value = module.alb.target_group_arn
}

output "target_group_name" {
  value = module.alb.target_group_name
}

output "cloudwatch_dashboard_name" {
  description = "CloudWatch dashboard name."

  value = module.monitoring.dashboard_name
}

output "sns_topic_arn" {
  description = "SNS topic ARN."

  value = module.monitoring.sns_topic_arn
}

output "backup_vault_name" {
  description = "AWS Backup vault name."

  value = module.backup.backup_vault_name
}

output "backup_vault_arn" {
  description = "AWS Backup vault ARN."

  value = module.backup.backup_vault_arn
}

output "backup_role_name" {
  description = "AWS Backup IAM role name."

  value = module.backup.backup_role_name
}

output "backup_role_arn" {
  description = "AWS Backup IAM role ARN."

  value = module.backup.backup_role_arn
}

output "cloudfront_distribution_id" {
  value = module.cloudfront.distribution_id
}

output "cloudfront_distribution_domain_name" {
  value = module.cloudfront.distribution_domain_name
}

output "cloudfront_distribution_arn" {
  value = module.cloudfront.distribution_arn
}

output "waf_web_acl_arn" {
  value = module.waf.web_acl_arn
}

output "waf_web_acl_id" {
  value = module.waf.web_acl_id
}

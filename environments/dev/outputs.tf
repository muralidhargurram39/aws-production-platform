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

output "vpc_flow_log_id" {
  value = module.network.vpc_flow_log_id
}

output "vpc_flow_log_log_group_name" {
  value = module.network.vpc_flow_log_log_group_name
}

output "access_analyzer_arn" {
  value = module.access_analyzer.analyzer_arn
}

output "access_analyzer_name" {
  value = module.access_analyzer.analyzer_name
}

#output "guardduty_detector_id" {
# value = module.guardduty.guardduty_detector_id
#}

#output "guardduty_detector_arn" {
# value = module.guardduty.guardduty_detector_arn
#}

output "replica_bucket_names" {
  description = "Names of the DR replica buckets"

  value = module.disaster_recovery.replica_bucket_names
}

output "replica_bucket_arns" {
  description = "ARNs of the DR replica buckets"

  value = module.disaster_recovery.replica_bucket_arns
}

output "route53_zone_id" {
  description = "Route53 Hosted Zone ID"
  value       = module.route53.zone_id
}

output "route53_name_servers" {
  description = "Route53 Name Servers"
  value       = module.route53.name_servers
}

output "acm_certificate_arn" {
  description = "CloudFront ACM Certificate ARN"
  value       = module.acm.certificate_arn
}

output "acm_certificate_status" {
  description = "CloudFront ACM Certificate Status"
  value       = module.acm.certificate_status
}

output "acm_domain_validation_options" {
  description = "ACM DNS Validation Records"
  value       = module.acm.domain_validation_options
}

output "acm_certificate_domain" {
  description = "Primary ACM certificate domain"
  value       = module.acm.certificate_domain_name
}

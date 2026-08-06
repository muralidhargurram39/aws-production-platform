data "aws_availability_zones" "available" {
  state = "available"
}

module "network" {
  source = "../../modules/network"

  project_name = var.project_name
  environment  = var.environment

  common_tags = local.common_tags

  vpc_cidr = var.vpc_cidr

  availability_zones = slice(
    data.aws_availability_zones.available.names,
    0,
    3
  )

  public_subnet_cidrs   = var.public_subnet_cidrs
  private_subnet_cidrs  = var.private_subnet_cidrs
  database_subnet_cidrs = var.database_subnet_cidrs

  enable_nat_gateway = var.enable_nat_gateway
}

module "security" {
  source = "../../modules/security"

  project_name = var.project_name
  environment  = var.environment

  vpc_id = module.network.vpc_id
}

module "iam" {
  source = "../../modules/iam"

  project_name = var.project_name
  environment  = var.environment
}

module "alb" {

  source = "../../modules/alb"

  project_name = var.project_name
  environment  = var.environment

  enable_deletion_protection = false

  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids

  alb_security_group_id = module.security.alb_security_group_id

  access_logs_enabled = true
  access_logs_bucket  = module.logging.bucket_name

  enable_https    = true
  certificate_arn = module.acm_regional.certificate_arn

  tags = local.common_tags

  depends_on = [
    module.logging
  ]
}

module "cloudfront" {

  source = "../../modules/cloudfront"

  project_name = var.project_name
  environment  = var.environment

  origin_domain_name = "origin.muralidharops.com"

  web_acl_id = module.waf.web_acl_arn

  aliases = [
    "muralidharops.com",
    "www.muralidharops.com"
  ]

  acm_certificate_arn = module.acm.certificate_arn


  logging_bucket = module.logging.cloudfront_logs_bucket_domain_name
  logging_prefix = "cloudfront/"


  tags = local.common_tags
}

module "compute" {
  source = "../../modules/compute"

  project_name = var.project_name
  environment  = var.environment

  ami_id = var.ami_id

  private_subnet_ids            = module.network.private_subnet_ids
  application_security_group_id = module.security.application_security_group_id
  instance_profile_name         = module.iam.instance_profile_name

  target_group_arns = [
    module.alb.target_group_arn
  ]

  instance_type    = "t3.micro"
  desired_capacity = 2
  min_size         = 2
  max_size         = 4

  root_volume_size = 20
}

module "monitoring" {
  source = "../../modules/monitoring"

  project_name = var.project_name
  environment  = var.environment

  autoscaling_group_name = module.compute.autoscaling_group_name

  load_balancer_arn_suffix = module.alb.alb_arn_suffix
  target_group_arn_suffix  = module.alb.target_group_arn_suffix
  nginx_log_group_name     = module.cloudwatch_agent.nginx_log_group_name
}

module "backup" {
  source = "../../modules/backup"

  project_name  = var.project_name
  environment   = var.environment
  force_destroy = var.force_destroy
}

module "waf" {

  source = "../../modules/waf"

  providers = {
    aws = aws.global
  }

  project_name = var.project_name
  environment  = var.environment

  enable_rate_limit = true
  rate_limit        = 2000

  tags = local.common_tags
}

module "logging" {

  source = "../../modules/logging"

  project_name = var.project_name
  environment  = var.environment
  aws_region   = var.aws_region

  tags                     = local.common_tags
  kms_key_arn              = module.kms.key_arn
  enable_cloudtrail_policy = true
  force_destroy            = true
}

module "config" {
  source = "../../modules/config"

  project_name  = var.project_name
  environment   = var.environment
  force_destroy = true
}

module "access_analyzer" {
  source = "../../modules/access-analyzer"

  project_name = var.project_name
  environment  = var.environment
}

#module "guardduty" {
# source = "../../modules/guardduty"

#project_name = var.project_name
#environment  = var.environment
#}

module "disaster_recovery" {
  source = "../../modules/disaster-recovery"

  providers = {
    aws    = aws
    aws.dr = aws.dr
  }
  force_destroy = true

  source_kms_key_arn = module.kms.key_arn

  kms_key_arn = module.kms_dr.key_arn

  project_name       = var.project_name
  environment        = var.environment
  account_id         = data.aws_caller_identity.current.account_id
  source_bucket_name = module.logging.logs_bucket_name
  source_bucket_arn  = module.logging.logs_bucket_arn
}

module "github_oidc" {

  source = "../../modules/github-oidc"

  github_owner      = "muralidhargurram39"
  github_repository = "aws-production-platform"

  project_name            = var.project_name
  environment             = var.environment
  backend_bucket_name     = "aws-production-platform-tf-state-2026"
  backend_lock_table_name = "aws-production-platform-terraform-lock"
}

module "route53" {

  source = "../../modules/route53"

  project_name = var.project_name
  environment  = var.environment

  domain_name = "muralidharops.com"

  cloudfront_domain_name = module.cloudfront.distribution_domain_name

  cloudfront_hosted_zone_id = "Z2FDTNDATAQYW2"

  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id  = module.alb.alb_zone_id


  tags = local.common_tags
}

module "acm" {

  source = "../../modules/acm"

  providers = {
    aws        = aws
    aws.global = aws.global
  }

  project_name = var.project_name
  environment  = var.environment

  domain_name = "muralidharops.com"

  subject_alternative_names = [
    "*.muralidharops.com"
  ]

  hosted_zone_id = module.route53.zone_id

  tags = local.common_tags
}

module "acm_regional" {

  source = "../../modules/acm-regional"

  project_name = var.project_name
  environment  = var.environment

  domain_name = "origin.muralidharops.com"

  hosted_zone_id = module.route53.zone_id

  tags = local.common_tags
}

module "kms" {

  source = "../../modules/kms"

  project_name         = var.project_name
  environment          = var.environment
  replication_role_arn = local.replication_role_arn
  aws_region           = var.aws_region

}

module "kms_dr" {

  source = "../../modules/kms"

  providers = {
    aws = aws.dr
  }

  project_name         = var.project_name
  environment          = "${var.environment}-dr"
  replication_role_arn = local.replication_role_arn
  aws_region           = "ap-south-1"

  #tags = local.common_tags
}

module "cloudtrail" {

  source = "../../modules/cloudtrail"

  project_name = var.project_name
  environment  = var.environment

  trail_bucket_name = module.logging.bucket_name
  kms_key_arn       = module.kms.key_arn
  depends_on = [
    module.logging
  ]
}

module "ssm" {

  source = "../../modules/ssm"

  project_name = var.project_name
  environment  = var.environment

  ec2_role_name = module.iam.ec2_role_name
}

module "cloudwatch_agent" {

  source = "../../modules/cloudwatch-agent"

  project_name = var.project_name
  environment  = var.environment

  tags = local.common_tags

  kms_key_arn = module.kms.key_arn

  depends_on = [
    module.ssm
  ]
}

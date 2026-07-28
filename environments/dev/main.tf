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

  vpc_id                = module.network.vpc_id
  public_subnet_ids     = module.network.public_subnet_ids
  alb_security_group_id = module.security.alb_security_group_id
  access_logs_enabled   = true
  access_logs_bucket    = module.logging.bucket_name
  access_logs_prefix    = "alb"
}

module "cloudfront" {

  source = "../../modules/cloudfront"

  project_name = var.project_name
  environment  = var.environment

  origin_domain_name = module.alb.alb_dns_name

  web_acl_id = module.waf.web_acl_arn


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
}

module "backup" {
  source = "../../modules/backup"

  project_name = var.project_name
  environment  = var.environment
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

  tags = local.common_tags
}

module "config" {
  source = "../../modules/config"

  project_name = var.project_name
  environment  = var.environment
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

  project_name       = var.project_name
  environment        = var.environment
  account_id         = data.aws_caller_identity.current.account_id
  source_bucket_name = module.logging.logs_bucket_name
  source_bucket_arn  = module.logging.logs_bucket_arn
}

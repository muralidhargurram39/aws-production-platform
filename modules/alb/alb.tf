resource "aws_lb" "application" {

  #checkov:skip=CKV2_AWS_28:ALB is intentionally protected behind CloudFront WAF; HTTPS origin access is restricted to the AWS CloudFront origin-facing managed prefix list.

  name = "${local.name_prefix}-alb"

  internal           = false
  load_balancer_type = "application"

  security_groups = [
    var.alb_security_group_id
  ]

  subnets = var.public_subnet_ids

  enable_deletion_protection = var.enable_deletion_protection

  enable_cross_zone_load_balancing = true

  idle_timeout = 60

  drop_invalid_header_fields = true

  enable_http2 = true

  dynamic "access_logs" {
    for_each = var.access_logs_enabled ? [1] : []

    content {
      enabled = true
      bucket  = var.access_logs_bucket
      prefix  = var.access_logs_prefix
    }
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-alb"
    }
  )

}

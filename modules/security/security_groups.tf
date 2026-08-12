resource "aws_security_group" "alb" {
  #checkov:skip=CKV2_AWS_5:ALB security group is attached to aws_lb.application through the alb_security_group_id module input.
  name        = "${local.name_prefix}-alb-sg"
  description = "Security group for Application Load Balancer"
  vpc_id      = var.vpc_id

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-alb-sg"
  })
}

resource "aws_security_group" "application" {
  #checkov:skip=CKV2_AWS_5:Application security group is attached to EC2 instances through aws_launch_template.application using application_security_group_id.
  name        = "${local.name_prefix}-app-sg"
  description = "Security group for application instances"
  vpc_id      = var.vpc_id

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-app-sg"
  })
}

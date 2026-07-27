resource "aws_autoscaling_group" "application" {
  name = "${local.name_prefix}-asg"

  desired_capacity = var.desired_capacity
  min_size         = var.min_size
  max_size         = var.max_size

  vpc_zone_identifier = var.private_subnet_ids

  health_check_type         = "ELB"
  health_check_grace_period = 300
  target_group_arns         = var.target_group_arns

  launch_template {
    id      = aws_launch_template.application.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${local.name_prefix}-application"
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = local.common_tags

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  instance_refresh {
    strategy = "Rolling"

    preferences {
      min_healthy_percentage = 50
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

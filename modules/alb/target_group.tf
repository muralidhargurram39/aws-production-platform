resource "aws_lb_target_group" "application" {

  name = "${local.name_prefix}-tg"

  port     = 80
  protocol = "HTTP"

  vpc_id = var.vpc_id

  target_type = "instance"

  deregistration_delay = 30

  load_balancing_algorithm_type = "round_robin"

  health_check {

    enabled = true

    protocol = "HTTP"

    path = "/"

    matcher = "200"

    interval = 30

    timeout = 5

    healthy_threshold = 2

    unhealthy_threshold = 2
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-target-group"
    }
  )

}

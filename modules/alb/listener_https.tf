resource "aws_lb_listener" "https" {

  count = var.enable_https ? 1 : 0

  load_balancer_arn = aws_lb.application.arn

  port     = 443
  protocol = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.application.arn
  }
}

data "aws_ec2_managed_prefix_list" "cloudfront_origin_facing" {
  name = "com.amazonaws.global.cloudfront.origin-facing"
}
resource "aws_vpc_security_group_ingress_rule" "application_http" {
  #checkov:skip=CKV_AWS_260:Application traffic is restricted to the ALB security group; TCP/80 is not exposed to 0.0.0.0/0. The ALB HTTPS listener forwards to the HTTP/80 target group.
  security_group_id = aws_security_group.application.id
  description       = "Allow HTTP traffic from the ALB"

  ip_protocol = "tcp"
  from_port   = 80
  to_port     = 80

  referenced_security_group_id = aws_security_group.alb.id
}

resource "aws_vpc_security_group_ingress_rule" "alb_https" {
  security_group_id = aws_security_group.alb.id
  description       = "Allow HTTPS traffic from CloudFront origin-facing servers"

  ip_protocol = "tcp"
  from_port   = 443
  to_port     = 443

  prefix_list_id = data.aws_ec2_managed_prefix_list.cloudfront_origin_facing.id
}

resource "aws_vpc_security_group_egress_rule" "alb_all" {
  security_group_id = aws_security_group.alb.id
  description       = "Allow outbound traffic from the ALB"
  ip_protocol       = "-1"

  cidr_ipv4 = "0.0.0.0/0"
}
resource "aws_vpc_security_group_egress_rule" "application_all" {
  security_group_id = aws_security_group.application.id

  description = "Allow outbound traffic from application instances"

  ip_protocol = "-1"

  cidr_ipv4 = "0.0.0.0/0"
}

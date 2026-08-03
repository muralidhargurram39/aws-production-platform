resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id
  description       = "Allow HTTP traffic from the Internet"

  ip_protocol = "tcp"
  from_port   = 80
  to_port     = 80

  cidr_ipv4 = "0.0.0.0/0"
}
resource "aws_vpc_security_group_ingress_rule" "alb_https" {
  security_group_id = aws_security_group.alb.id
  description       = "Allow HTTPS traffic from the Internet"

  ip_protocol = "tcp"
  from_port   = 443
  to_port     = 443

  cidr_ipv4 = "0.0.0.0/0"
}
resource "aws_vpc_security_group_egress_rule" "alb_all" {
  security_group_id = aws_security_group.alb.id
  description       = "Allow outbound traffic from the ALB"
  ip_protocol       = "-1"

  cidr_ipv4 = "0.0.0.0/0"
}
resource "aws_vpc_security_group_ingress_rule" "application_http" {
  security_group_id = aws_security_group.application.id
  description       = "Allow HTTP traffic from the ALB"

  ip_protocol = "tcp"
  from_port   = 80
  to_port     = 80

  referenced_security_group_id = aws_security_group.alb.id
}
resource "aws_vpc_security_group_egress_rule" "application_all" {
  security_group_id = aws_security_group.application.id

  description = "Allow outbound traffic from application instances"

  ip_protocol = "-1"

  cidr_ipv4 = "0.0.0.0/0"
}
resource "aws_vpc_security_group_ingress_rule" "database_postgres" {
  security_group_id = aws_security_group.database.id

  description = "Allow PostgreSQL access from application instances"

  ip_protocol = "tcp"
  from_port   = 5432
  to_port     = 5432

  referenced_security_group_id = aws_security_group.application.id
}
resource "aws_vpc_security_group_egress_rule" "database_all" {
  security_group_id = aws_security_group.database.id

  description = "Allow outbound traffic from database instance"

  ip_protocol = "-1"

  cidr_ipv4 = "0.0.0.0/0"
}
resource "aws_vpc_security_group_egress_rule" "management_all" {
  security_group_id = aws_security_group.management.id

  description = "Allow outbound traffic from management resources"


  ip_protocol = "-1"

  cidr_ipv4 = "0.0.0.0/0"
}

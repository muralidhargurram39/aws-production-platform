resource "aws_default_security_group" "this" {

  vpc_id = aws_vpc.this.id

  ingress = []
  egress  = []

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-default-sg"
    }
  )
}

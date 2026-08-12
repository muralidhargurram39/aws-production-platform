locals {

  name_prefix = "${var.project_name}-${var.environment}"

  common_tags = merge(
    var.tags,
    {
      Name = "${local.name_prefix}-route53"
    }
  )
}

resource "aws_route53_zone" "main" {

  name = var.domain_name

  comment = "Hosted zone for ${var.domain_name}"

  tags = local.common_tags
}

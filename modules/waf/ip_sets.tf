resource "aws_wafv2_ip_set" "allow" {

  count = length(var.ip_allow_list) > 0 ? 1 : 0

  provider = aws

  name               = "${local.name_prefix}-allow"
  scope              = "CLOUDFRONT"
  ip_address_version = "IPV4"

  addresses = var.ip_allow_list

  tags = local.common_tags
}

resource "aws_wafv2_ip_set" "block" {

  count = length(var.ip_block_list) > 0 ? 1 : 0

  provider = aws

  name               = "${local.name_prefix}-block"
  scope              = "CLOUDFRONT"
  ip_address_version = "IPV4"

  addresses = var.ip_block_list

  tags = local.common_tags
}

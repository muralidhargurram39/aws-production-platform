resource "aws_kms_key" "route53_dnssec" {
  provider = aws.global

  description              = "KMS key for Route 53 DNSSEC signing"
  key_usage                = "SIGN_VERIFY"
  customer_master_key_spec = "ECC_NIST_P256"

  policy = data.aws_iam_policy_document.route53_dnssec_kms.json

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-route53-dnssec"
    }
  )
}

resource "aws_kms_alias" "route53_dnssec" {
  provider = aws.global

  name          = "alias/${local.name_prefix}-route53-dnssec"
  target_key_id = aws_kms_key.route53_dnssec.key_id
}

resource "aws_route53_key_signing_key" "main" {
  provider = aws.global

  hosted_zone_id             = aws_route53_zone.main.zone_id
  key_management_service_arn = aws_kms_key.route53_dnssec.arn
  name                       = "${local.name_prefix}-dnssec"
  status                     = "ACTIVE"
}

resource "aws_route53_hosted_zone_dnssec" "main" {
  provider = aws.global

  hosted_zone_id = aws_route53_zone.main.zone_id

  depends_on = [
    aws_route53_key_signing_key.main
  ]
}

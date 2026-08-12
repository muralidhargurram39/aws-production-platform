resource "aws_cloudfront_distribution" "main" {

  #checkov:skip=CKV2_AWS_47:CloudFront is associated with the CLOUDFRONT WAF WebACL, which includes AWSManagedRulesKnownBadInputsRuleSet containing the Log4j protections.
  #checkov:skip=CKV_AWS_310:Single ALB origin is intentional for this environment; no independent secondary origin currently exists for meaningful CloudFront origin failover.
  #checkov:skip=CKV_AWS_374:Distribution is intentionally globally accessible; no geographic access restriction is required for this application.

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "${local.name_prefix} distribution"
  default_root_object = "index.html"

  web_acl_id = var.web_acl_id

  aliases = var.aliases

  logging_config {
    bucket = var.logging_bucket
    prefix = var.logging_prefix
  }

  origin {

    domain_name = var.origin_domain_name
    origin_id   = "alb-origin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"

      origin_ssl_protocols = [
        "TLSv1.2"
      ]
    }

  }

  default_cache_behavior {

    target_origin_id       = "alb-origin"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = [
      "GET",
      "HEAD",
      "OPTIONS"
    ]

    cached_methods = [
      "GET",
      "HEAD"
    ]

    cache_policy_id = data.aws_cloudfront_cache_policy.caching_optimized.id

    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.all_viewer.id

    response_headers_policy_id = data.aws_cloudfront_response_headers_policy.security_headers.id
    compress                   = true

  }

  restrictions {

    geo_restriction {
      restriction_type = "none"
    }

  }

  viewer_certificate {

    acm_certificate_arn = var.acm_certificate_arn

    ssl_support_method = "sni-only"

    minimum_protocol_version = "TLSv1.2_2021"
  }

  price_class = "PriceClass_100"


  tags = local.common_tags
}

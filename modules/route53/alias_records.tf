resource "aws_route53_record" "root" {

  zone_id = aws_route53_zone.main.zone_id

  name = var.domain_name

  type = "A"

  alias {

    name = var.cloudfront_domain_name

    zone_id = var.cloudfront_hosted_zone_id

    evaluate_target_health = false
  }
}

resource "aws_route53_record" "root_ipv6" {

  zone_id = aws_route53_zone.main.zone_id

  name = var.domain_name

  type = "AAAA"

  alias {

    name = var.cloudfront_domain_name

    zone_id = var.cloudfront_hosted_zone_id

    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www" {

  zone_id = aws_route53_zone.main.zone_id

  name = "www.${var.domain_name}"

  type = "A"

  alias {

    name = var.cloudfront_domain_name

    zone_id = var.cloudfront_hosted_zone_id

    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www_ipv6" {

  zone_id = aws_route53_zone.main.zone_id

  name = "www.${var.domain_name}"

  type = "AAAA"

  alias {

    name = var.cloudfront_domain_name

    zone_id = var.cloudfront_hosted_zone_id

    evaluate_target_health = false
  }
}



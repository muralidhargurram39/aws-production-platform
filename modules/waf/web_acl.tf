resource "aws_wafv2_web_acl" "main" {

  name  = "${local.name_prefix}-web-acl"
  scope = "CLOUDFRONT"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${local.name_prefix}-web-acl"
    sampled_requests_enabled   = true
  }

  #
  # AWS Managed Rules - Common Rule Set
  #
  rule {

    name     = "AWSManagedCommonRuleSet"
    priority = 10

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesCommonRuleSet"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "CommonRuleSet"
      sampled_requests_enabled   = true
    }
  }

  #
  # AWS Managed Rules - Known Bad Inputs
  #
  rule {

    name     = "AWSManagedKnownBadInputsRuleSet"
    priority = 20

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "KnownBadInputs"
      sampled_requests_enabled   = true
    }
  }

  #
  # AWS Managed Rules - Linux
  #
  rule {

    name     = "AWSManagedLinuxRuleSet"
    priority = 30

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesLinuxRuleSet"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "LinuxRuleSet"
      sampled_requests_enabled   = true
    }
  }

  #
  # AWS Managed Rules - Amazon IP Reputation
  #
  rule {

    name     = "AWSManagedAmazonIpReputationList"
    priority = 40

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesAmazonIpReputationList"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "IpReputation"
      sampled_requests_enabled   = true
    }
  }

  #
  # Rate Limiting
  #
  dynamic "rule" {

    for_each = var.enable_rate_limit ? [1] : []

    content {

      name     = "RateLimit"
      priority = 100

      action {
        block {}
      }

      statement {

        rate_based_statement {
          aggregate_key_type = "IP"
          limit              = var.rate_limit
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "RateLimit"
        sampled_requests_enabled   = true
      }
    }
  }

  tags = local.common_tags
}

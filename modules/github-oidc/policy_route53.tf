data "aws_iam_policy_document" "route53" {
  #
  # CreateHostedZone operates before the hosted zone exists, so AWS requires
  # Resource="*" for this API.
  #
  #checkov:skip=CKV_AWS_111:CreateHostedZone requires Resource=* because the hosted zone does not exist before creation.
  #checkov:skip=CKV_AWS_356:CreateHostedZone does not support resource-level permissions.

  statement {
    sid    = "Route53HostedZoneCreate"
    effect = "Allow"

    actions = [
      "route53:CreateHostedZone",
    ]

    resources = [
      "*",
    ]
  }

  #
  # Hosted-zone lifecycle and DNS record management.
  #
  statement {
    sid    = "Route53HostedZoneManagement"
    effect = "Allow"

    actions = [
      "route53:GetHostedZone",
      "route53:DeleteHostedZone",
      "route53:ChangeResourceRecordSets",
      "route53:ListResourceRecordSets",
      "route53:ChangeTagsForResource",
      "route53:ListTagsForResource",
    ]

    resources = [
      "arn:aws:route53:::hostedzone/*",
    ]
  }

  #
  # List operations do not support hosted-zone resource scoping.
  #
  #checkov:skip=CKV_AWS_111:Route 53 list operations require Resource=*.
  #checkov:skip=CKV_AWS_356:Route 53 list operations do not support resource-level permissions.

  statement {
    sid    = "Route53Read"
    effect = "Allow"

    actions = [
      "route53:ListHostedZones",
      "route53:ListHostedZonesByName",
    ]

    resources = [
      "*",
    ]
  }

  #
  # GetChange operates against a Route 53 change resource.
  #
  #checkov:skip=CKV_AWS_111:GetChange requires Resource=* in the Route 53 IAM model.
  #checkov:skip=CKV_AWS_356:GetChange does not support resource-level permissions.

  statement {
    sid    = "Route53ChangeRead"
    effect = "Allow"

    actions = [
      "route53:GetChange",
    ]

    resources = [
      "*",
    ]
  }

  #
  # DNSSEC management is associated with the hosted zone.
  #
  statement {
    sid    = "Route53DNSSEC"
    effect = "Allow"

    actions = [
      "route53:CreateKeySigningKey",
      "route53:DeleteKeySigningKey",
      "route53:GetDNSSEC",
      "route53:ActivateKeySigningKey",
      "route53:DeactivateKeySigningKey",
      "route53:EnableHostedZoneDNSSEC",
      "route53:DisableHostedZoneDNSSEC",
    ]

    resources = [
      "arn:aws:route53:::hostedzone/*",
    ]
  }

  #
  # Query logging configuration is account-level in the Route 53 IAM model.
  #
  #checkov:skip=CKV_AWS_111:Route 53 query logging configuration APIs require Resource=*.
  #checkov:skip=CKV_AWS_356:Route 53 query logging configuration APIs do not support resource-level permissions.

  statement {
    sid    = "Route53QueryLogging"
    effect = "Allow"

    actions = [
      "route53:CreateQueryLoggingConfig",
      "route53:DeleteQueryLoggingConfig",
      "route53:GetQueryLoggingConfig",
      "route53:ListQueryLoggingConfigs",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "route53" {
  name        = "${local.name_prefix}-route53-policy"
  description = "Route 53 management for the platform"
  policy      = data.aws_iam_policy_document.route53.json
}

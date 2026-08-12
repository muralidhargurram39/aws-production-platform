data "aws_iam_policy_document" "terraform" {

  #
  # Terraform Backend
  #
  statement {

    sid    = "TerraformBackend"
    effect = "Allow"

    actions = [
      "s3:*",
      "dynamodb:*"
    ]

    resources = [
      "*"
    ]
  }

  #
  # Identity
  #
  statement {

    sid    = "Identity"
    effect = "Allow"

    actions = [
      "iam:*",
      "sts:GetCallerIdentity"
    ]

    resources = [
      "*"
    ]
  }

  #
  # Resource Tagging
  #
  statement {

    sid    = "Tagging"
    effect = "Allow"

    actions = [
      "tag:*"
    ]

    resources = [
      "*"
    ]
  }
  #
  # Networking
  #
  statement {

    sid    = "Networking"
    effect = "Allow"

    actions = [
      "ec2:*",
      "elasticloadbalancing:*",
      "autoscaling:*"
    ]

    resources = [
      "*"
    ]
  }
  #
  # Monitoring
  #
  statement {

    sid    = "Monitoring"
    effect = "Allow"

    actions = [
      "cloudwatch:*",
      "logs:*",
      "sns:*"
    ]

    resources = [
      "*"
    ]
  }

  #
  # Security
  #
  statement {

    sid    = "Security"
    effect = "Allow"

    actions = [
      "kms:*",
      "wafv2:*",
      "guardduty:*",
      "securityhub:*"
    ]

    resources = [
      "*"
    ]
  }

  #
  # Governance
  #
  statement {

    sid    = "Governance"
    effect = "Allow"

    actions = [
      "config:*",
      "access-analyzer:*"
    ]

    resources = [
      "*"
    ]
  }

  #
  # Backup
  #
  statement {

    sid    = "Backup"
    effect = "Allow"

    actions = [
      "backup:*"
    ]

    resources = [
      "*"
    ]
  }

  #
  # CDN
  #
  statement {

    sid    = "CDN"
    effect = "Allow"

    actions = [
      "cloudfront:*"
    ]

    resources = [
      "*"
    ]
  }

}

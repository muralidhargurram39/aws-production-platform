data "aws_iam_policy_document" "security" {

  #
  # KMS
  #
  statement {

    sid    = "KMS"
    effect = "Allow"

    actions = [
      "kms:CreateKey",
      "kms:DescribeKey",
      "kms:EnableKeyRotation",
      "kms:DisableKeyRotation",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion",
      "kms:CreateAlias",
      "kms:DeleteAlias",
      "kms:ListAliases",
      "kms:TagResource",
      "kms:UntagResource"
    ]

    resources = ["*"]
  }

  #
  # WAFv2
  #
  statement {

    sid    = "WAF"
    effect = "Allow"

    actions = [
      "wafv2:CreateWebACL",
      "wafv2:DeleteWebACL",
      "wafv2:GetWebACL",
      "wafv2:UpdateWebACL",
      "wafv2:ListWebACLs",
      "wafv2:AssociateWebACL",
      "wafv2:DisassociateWebACL",
      "wafv2:TagResource",
      "wafv2:UntagResource"
    ]

    resources = ["*"]
  }

  #
  # GuardDuty
  #
  statement {

    sid    = "GuardDuty"
    effect = "Allow"

    actions = [
      "guardduty:CreateDetector",
      "guardduty:DeleteDetector",
      "guardduty:GetDetector",
      "guardduty:UpdateDetector",
      "guardduty:ListDetectors"
    ]

    resources = ["*"]
  }

  #
  # Security Hub
  #
  statement {

    sid    = "SecurityHub"
    effect = "Allow"

    actions = [
      "securityhub:EnableSecurityHub",
      "securityhub:DisableSecurityHub",
      "securityhub:DescribeHub",
      "securityhub:GetFindings",
      "securityhub:BatchImportFindings",
      "securityhub:TagResource",
      "securityhub:UntagResource"
    ]

    resources = ["*"]
  }
}

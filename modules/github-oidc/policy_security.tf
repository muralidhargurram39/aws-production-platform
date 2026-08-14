data "aws_iam_policy_document" "security" {

  #
  # KMS account-level read operations
  #
  # ListAliases is an account-level read operation and does not support
  # the aws:RequestTag/Project condition used by CreateKey.
  #
  statement {
    sid    = "KMSAccountRead"
    effect = "Allow"

    actions = [
      "kms:ListAliases"
    ]

    resources = ["*"]
  }

  #
  # KMS key creation
  #
  # Restrict creation to keys requested with the project tag.
  #
  statement {
    sid    = "KMSKeyCreation"
    effect = "Allow"

    actions = [
      "kms:CreateKey"
    ]

    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/Project"

      values = [
        var.project_name
      ]
    }
  }

  #
  # KMS key management
  #
  # Restrict key management to keys tagged for this project.
  #
  statement {
    sid    = "KMSKeyManagement"
    effect = "Allow"

    actions = [
      "kms:DescribeKey",
      "kms:EnableKeyRotation",
      "kms:DisableKeyRotation",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ListResourceTags",
      "kms:PutKeyPolicy",
      "kms:GetKeyPolicy",
      "kms:GetKeyRotationStatus"
    ]

    resources = [
      "arn:aws:kms:*:${data.aws_caller_identity.current.account_id}:key/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/Project"

      values = [
        var.project_name
      ]
    }
  }

  #
  # KMS alias management
  #
  # KMS alias operations are authorized against alias resources.
  #
  statement {
    sid    = "KMSAliasManagement"
    effect = "Allow"

    actions = [
      "kms:CreateAlias",
      "kms:DeleteAlias",
      "kms:UpdateAlias"
    ]

    resources = [
      "arn:aws:kms:*:${data.aws_caller_identity.current.account_id}:alias/${local.name_prefix}-*"
    ]
  }

  #
  # WAFv2 WebACL creation
  #
  # CreateWebACL is a creation/control-plane operation. The WebACL does
  # not exist yet, so use Resource="*".
  #
  # The management statement below restricts operations on existing
  # WebACLs using the Project resource tag.
  #
  #checkov:skip=CKV_AWS_109:WAFv2 CreateWebACL requires wildcard resource scope
  #checkov:skip=CKV_AWS_111:WAFv2 CreateWebACL requires wildcard resource scope
  #checkov:skip=CKV_AWS_356:WAFv2 CreateWebACL requires wildcard resource scope
  statement {
    sid    = "WAFWebACLCreate"
    effect = "Allow"

    actions = [
      "wafv2:CreateWebACL"
    ]

    resources = ["*"]
  }

  #
  # WAFv2 WebACL management
  #
  statement {
    sid    = "WAFWebACLManagement"
    effect = "Allow"

    actions = [
      "wafv2:DeleteWebACL",
      "wafv2:GetWebACL",
      "wafv2:PutLoggingConfiguration",
      "wafv2:GetLoggingConfiguration",
      "wafv2:DeleteLoggingConfiguration",
      "wafv2:UpdateWebACL",
      "wafv2:TagResource",
      "wafv2:UntagResource"
    ]

    resources = [
      "arn:aws:wafv2:us-east-1:${data.aws_caller_identity.current.account_id}:global/webacl/${local.name_prefix}-web-acl/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/Project"

      values = [
        var.project_name
      ]
    }
  }

  #
  # WAFv2 read/list operations
  #
  statement {
    sid    = "WAFRead"
    effect = "Allow"

    actions = [
      "wafv2:ListWebACLs",
      "wafv2:ListTagsForResource"
    ]

    resources = ["*"]
  }
}

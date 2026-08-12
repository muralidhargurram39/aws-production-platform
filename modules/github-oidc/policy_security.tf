data "aws_iam_policy_document" "security" {

  #
  # KMS account-level read operations
  #
  # ListAliases is an account-level read operation and must not depend
  # on a CreateKey request-tag condition.
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
  # CreateKey is constrained by the Project request tag.
  #
  statement {
    sid    = "KMSKeyCreate"
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
  # Restrict management to KMS keys tagged for this project.
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
  # CreateAlias requires authorization for the alias resource in the IAM
  # policy and the target key in the KMS key policy.
  #
  statement {
    sid    = "KMSAliasManagement"
    effect = "Allow"

    actions = [
      "kms:CreateAlias",
      "kms:DeleteAlias"
    ]

    resources = [
      "arn:aws:kms:*:${data.aws_caller_identity.current.account_id}:alias/${local.name_prefix}-*",
      "arn:aws:kms:*:${data.aws_caller_identity.current.account_id}:key/*"
    ]
  }

  #
  # WAFv2 - CloudFront WebACL
  #
  # CloudFront WAFv2 resources use us-east-1 and the global scope.
  #
  #
  # WAFv2 - CloudFront WebACL creation
  #
  # CreateWebACL is a creation/control-plane operation. The WebACL does
  # not exist yet, so IAM cannot constrain this action to the final
  # WebACL ARN. Restrict creation using the required Project request tag.
  #
  #checkov:skip=CKV_AWS_109:WAFv2 CreateWebACL requires wildcard resource scope and is constrained by the Project request tag
  #checkov:skip=CKV_AWS_111:WAFv2 CreateWebACL requires wildcard resource scope and is constrained by the Project request tag
  #checkov:skip=CKV_AWS_356:WAFv2 CreateWebACL requires wildcard resource scope and is constrained by the Project request tag
  statement {
    sid    = "WAFWebACLCreate"
    effect = "Allow"

    actions = [
      "wafv2:CreateWebACL"
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
  # WAFv2 WebACL management
  #
  statement {
    sid    = "WAFWebACLManagement"
    effect = "Allow"

    actions = [
      "wafv2:DeleteWebACL",
      "wafv2:GetWebACL",
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
  # WAFv2 discovery
  #
  # ListWebACLs is an account-level list operation.
  #
  statement {
    sid    = "WAFRead"
    effect = "Allow"

    actions = [
      "wafv2:ListWebACLs"
    ]

    resources = ["*"]
  }
}

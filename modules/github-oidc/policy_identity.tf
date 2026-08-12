data "aws_iam_policy_document" "identity" {

  #
  # IAM Read
  #
  # Keep account-level discovery permissions separate from resource-scoped
  # IAM reads. This avoids granting broad iam:Get*/iam:List* permissions.
  #
  statement {
    sid    = "IAMRead"
    effect = "Allow"

    actions = [
      "sts:GetCallerIdentity"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "IAMRoleRead"
    effect = "Allow"

    actions = [
      "iam:GetRole",
      "iam:ListAttachedRolePolicies",
      "iam:ListRolePolicies",
      "iam:ListRoleTags"
    ]

    resources = [
      local.iam_role_arn
    ]
  }

  statement {
    sid    = "IAMPolicyRead"
    effect = "Allow"

    actions = [
      "iam:GetPolicy",
      "iam:GetPolicyVersion",
      "iam:ListPolicyVersions",
      "iam:ListPolicyTags"
    ]

    resources = [
      local.iam_policy_arn
    ]
  }

  statement {
    sid    = "InstanceProfileRead"
    effect = "Allow"

    actions = [
      "iam:GetInstanceProfile"
    ]

    resources = [
      local.instance_profile_arn
    ]
  }

  statement {
    sid    = "OIDCProviderRead"
    effect = "Allow"

    actions = [
      "iam:GetOpenIDConnectProvider"
    ]

    resources = [
      local.oidc_provider_arn
    ]
  }

  #
  # IAM Role Creation
  #
  # CreateRole supports resource-level permissions.
  #
  statement {
    sid    = "IAMRoleCreate"
    effect = "Allow"

    actions = [
      "iam:CreateRole"
    ]

    resources = [
      local.iam_role_arn
    ]
  }

  #
  # IAM Role Management
  #
  statement {
    sid    = "IAMRoleManagement"
    effect = "Allow"

    actions = [
      "iam:DeleteRole",
      "iam:UpdateRole",
      "iam:UpdateAssumeRolePolicy",
      "iam:TagRole",
      "iam:UntagRole",
      "iam:AttachRolePolicy",
      "iam:DetachRolePolicy",
      "iam:PassRole"
    ]

    resources = [
      local.iam_role_arn
    ]
  }

  #
  # IAM Policy Creation
  #
  statement {
    sid    = "IAMPolicyCreate"
    effect = "Allow"

    actions = [
      "iam:CreatePolicy"
    ]

    resources = [
      local.iam_policy_arn
    ]
  }

  #
  # IAM Policy Management
  #
  statement {
    sid    = "IAMPolicyManagement"
    effect = "Allow"

    actions = [
      "iam:DeletePolicy",
      "iam:CreatePolicyVersion",
      "iam:DeletePolicyVersion",
      "iam:SetDefaultPolicyVersion"
    ]

    resources = [
      local.iam_policy_arn
    ]
  }

  #
  # Instance Profile Creation
  #
  statement {
    sid    = "InstanceProfileCreate"
    effect = "Allow"

    actions = [
      "iam:CreateInstanceProfile"
    ]

    resources = [
      local.instance_profile_arn
    ]
  }

  #
  # Instance Profile Management
  #
  statement {
    sid    = "InstanceProfileManagement"
    effect = "Allow"

    actions = [
      "iam:DeleteInstanceProfile",
      "iam:AddRoleToInstanceProfile",
      "iam:RemoveRoleFromInstanceProfile",
      "iam:TagInstanceProfile",
      "iam:UntagInstanceProfile"
    ]

    resources = [
      local.instance_profile_arn
    ]
  }

  #
  # GitHub OIDC Provider Creation
  #
  statement {
    sid    = "OIDCProviderCreate"
    effect = "Allow"

    actions = [
      "iam:CreateOpenIDConnectProvider"
    ]

    resources = [
      local.oidc_provider_arn
    ]
  }

  #
  # GitHub OIDC Provider Management
  #
  statement {
    sid    = "OIDCProviderManagement"
    effect = "Allow"

    actions = [
      "iam:DeleteOpenIDConnectProvider",
      "iam:UpdateOpenIDConnectProviderThumbprint"
    ]

    resources = [
      local.oidc_provider_arn
    ]
  }
}

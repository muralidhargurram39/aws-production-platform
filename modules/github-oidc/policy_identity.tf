data "aws_iam_policy_document" "identity" {

  #
  # IAM Read
  #
  statement {

    sid    = "IAMRead"
    effect = "Allow"

    actions = [
      "iam:Get*",
      "iam:List*",
      "sts:GetCallerIdentity"
    ]

    resources = ["*"]
  }

  #
  # IAM Role Creation
  # (Create APIs require "*" because the resource does not exist yet.)
  #
  statement {

    sid    = "IAMRoleCreate"
    effect = "Allow"

    actions = [
      "iam:CreateRole"
    ]

    resources = ["*"]
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

    resources = ["*"]
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

    resources = ["*"]
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
      "iam:RemoveRoleFromInstanceProfile"
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

    resources = ["*"]
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

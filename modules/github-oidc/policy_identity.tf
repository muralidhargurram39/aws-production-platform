data "aws_iam_policy_document" "identity" {

  statement {

    sid    = "Identity"
    effect = "Allow"

    actions = [

      # Read
      "iam:Get*",
      "iam:List*",

      # Roles
      "iam:CreateRole",
      "iam:DeleteRole",
      "iam:UpdateRole",
      "iam:UpdateAssumeRolePolicy",
      "iam:TagRole",
      "iam:UntagRole",

      # Policies
      "iam:CreatePolicy",
      "iam:DeletePolicy",
      "iam:CreatePolicyVersion",
      "iam:DeletePolicyVersion",
      "iam:SetDefaultPolicyVersion",

      # Attachments
      "iam:AttachRolePolicy",
      "iam:DetachRolePolicy",

      # Instance Profiles
      "iam:CreateInstanceProfile",
      "iam:DeleteInstanceProfile",
      "iam:AddRoleToInstanceProfile",
      "iam:RemoveRoleFromInstanceProfile",

      # Pass Role
      "iam:PassRole",

      # OIDC
      "iam:CreateOpenIDConnectProvider",
      "iam:DeleteOpenIDConnectProvider",
      "iam:UpdateOpenIDConnectProviderThumbprint",

      # STS
      "sts:GetCallerIdentity"
    ]

    resources = ["*"]
  }
}

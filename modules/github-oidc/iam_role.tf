data "aws_iam_policy_document" "github_assume_role" {

  statement {

    effect = "Allow"

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {

      type = "Federated"

      identifiers = [
        aws_iam_openid_connect_provider.github.arn
      ]
    }

    condition {

      test = "StringEquals"

      variable = "token.actions.githubusercontent.com:aud"

      values = [
        "sts.amazonaws.com"
      ]
    }

    condition {

      test = "StringLike"

      variable = "token.actions.githubusercontent.com:sub"

      values = [
        "repo:${var.github_owner}/${var.github_repository}:*"
      ]
    }
  }
}

resource "aws_iam_role" "github_actions" {

  name = "${var.project_name}-${var.environment}-github-actions"

  assume_role_policy = data.aws_iam_policy_document.github_assume_role.json

  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_iam_role_policy_attachment" "administrator" {

  role = aws_iam_role.github_actions.name

  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

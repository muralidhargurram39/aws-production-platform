resource "aws_iam_policy" "terraform" {

  name        = "${var.project_name}-${var.environment}-terraform-policy"
  description = "Terraform deployment policy for GitHub Actions"

  policy = data.aws_iam_policy_document.terraform.json
}

resource "aws_iam_role_policy_attachment" "terraform" {

  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.terraform.arn
}

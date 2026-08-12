locals {

  github_policy_arns = {

    backend    = aws_iam_policy.backend.arn
    identity   = aws_iam_policy.identity.arn
    networking = aws_iam_policy.networking.arn
    monitoring = aws_iam_policy.monitoring.arn
    security   = aws_iam_policy.security.arn
    governance = aws_iam_policy.governance.arn
    backup     = aws_iam_policy.backup.arn
    cloudfront = aws_iam_policy.cloudfront.arn
    tagging    = aws_iam_policy.tagging.arn
    acm        = aws_iam_policy.acm.arn
    route53    = aws_iam_policy.route53.arn
  }
}

resource "aws_iam_role_policy_attachment" "github_actions" {

  for_each = local.github_policy_arns

  role       = aws_iam_role.github_actions.name
  policy_arn = each.value
}

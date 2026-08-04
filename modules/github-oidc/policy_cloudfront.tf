data "aws_iam_policy_document" "cloudfront" {

  #
  # CloudFront Distribution Management
  #
  statement {

    sid    = "CloudFrontDistribution"
    effect = "Allow"

    actions = [
      "cloudfront:CreateDistribution",
      "cloudfront:DeleteDistribution",
      "cloudfront:GetDistribution",
      "cloudfront:GetDistributionConfig",
      "cloudfront:UpdateDistribution",
      "cloudfront:ListDistributions",
      "cloudfront:TagResource",
      "cloudfront:UntagResource",
      "cloudfront:ListTagsForResource"
    ]

    resources = ["*"]
  }

  #
  # AWS Managed Policies
  #
  statement {

    sid    = "CloudFrontManagedPolicies"
    effect = "Allow"

    actions = [
      "cloudfront:GetCachePolicy",
      "cloudfront:ListCachePolicies",

      "cloudfront:GetOriginRequestPolicy",
      "cloudfront:ListOriginRequestPolicies",

      "cloudfront:GetResponseHeadersPolicy",
      "cloudfront:ListResponseHeadersPolicies"
    ]

    resources = ["*"]
  }
}

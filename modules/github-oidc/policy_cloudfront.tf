data "aws_iam_policy_document" "cloudfront" {

  #
  # CloudFront Distribution Management
  #
  #
  # CloudFront distribution management.
  #
  # CloudFront distribution creation and several distribution-level
  # control-plane APIs require Resource="*".
  #
  #checkov:skip=CKV_AWS_109:CloudFront distribution control-plane APIs require wildcard resource scope
  #checkov:skip=CKV_AWS_111:CloudFront distribution creation/control-plane APIs require wildcard resource scope
  #checkov:skip=CKV_AWS_356:CloudFront distribution control-plane APIs require Resource=*

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

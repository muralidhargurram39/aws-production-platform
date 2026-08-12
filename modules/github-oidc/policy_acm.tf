data "aws_iam_policy_document" "acm" {
  statement {
    sid    = "ACMCertificateManagement"
    effect = "Allow"

    actions = [
      "acm:RequestCertificate",
      "acm:DescribeCertificate",
      "acm:DeleteCertificate",
      "acm:GetCertificate",
      "acm:ListCertificates",
      "acm:ListTagsForCertificate",
      "acm:AddTagsToCertificate",
      "acm:RemoveTagsFromCertificate",
    ]

    resources = [
      "arn:aws:acm:*:${data.aws_caller_identity.current.account_id}:certificate/*",
    ]
  }
}

resource "aws_iam_policy" "acm" {
  name        = "${local.name_prefix}-acm-policy"
  description = "ACM certificate management for the platform"
  policy      = data.aws_iam_policy_document.acm.json
}

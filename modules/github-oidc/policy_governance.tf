data "aws_iam_policy_document" "governance" {

  #
  # AWS Config
  #
  # AWS Config control-plane APIs used to create/manage the configuration
  # recorder and delivery channel require wildcard resource scope.
  #
  #checkov:skip=CKV_AWS_109:AWS Config control-plane APIs require wildcard resource scope
  #checkov:skip=CKV_AWS_111:AWS Config control-plane APIs require wildcard resource scope
  #checkov:skip=CKV_AWS_356:AWS Config control-plane APIs require Resource=*
  statement {
    sid    = "Config"
    effect = "Allow"

    actions = [
      "config:PutConfigurationRecorder",
      "config:DeleteConfigurationRecorder",
      "config:DescribeConfigurationRecorders",
      "config:PutDeliveryChannel",
      "config:DeleteDeliveryChannel",
      "config:DescribeDeliveryChannels",
      "config:DescribeConfigurationRecorderStatus",
      "config:StartConfigurationRecorder",
      "config:StopConfigurationRecorder",
      "config:PutConfigRule",
      "config:DeleteConfigRule",
      "config:DescribeConfigRules",
      "config:TagResource",
      "config:UntagResource"
    ]

    resources = ["*"]
  }

  #
  # IAM Access Analyzer
  #
  # Analyzer creation is an account/region control-plane operation.
  #
  statement {
    sid    = "AccessAnalyzer"
    effect = "Allow"

    actions = [
      "access-analyzer:CreateAnalyzer",
      "access-analyzer:DeleteAnalyzer",
      "access-analyzer:GetAnalyzer",
      "access-analyzer:ListAnalyzers",
      "access-analyzer:TagResource",
      "access-analyzer:UntagResource"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "IAMPolicyTagging"
    effect = "Allow"

    actions = [
      "iam:TagPolicy",
      "iam:UntagPolicy"
    ]

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/${var.project_name}-${var.environment}-*"
    ]
  }

}

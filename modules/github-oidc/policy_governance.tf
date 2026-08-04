data "aws_iam_policy_document" "governance" {

  #
  # AWS Config
  #
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
  # Access Analyzer
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
}

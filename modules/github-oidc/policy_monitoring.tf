data "aws_iam_policy_document" "monitoring" {

  #
  # Monitoring resources are created dynamically by Terraform.
  # Several CloudWatch Logs/SNS/CloudWatch control-plane APIs require
  # wildcard resource scope at creation time.
  #
  #checkov:skip=CKV_AWS_109:Monitoring creation/control-plane APIs require wildcard resource scope
  #checkov:skip=CKV_AWS_111:Monitoring creation/control-plane APIs require wildcard resource scope
  #checkov:skip=CKV_AWS_356:Monitoring creation/control-plane APIs require Resource=*
  statement {
    sid    = "Monitoring"
    effect = "Allow"

    actions = [
      "cloudwatch:PutMetricAlarm",
      "cloudwatch:DeleteAlarms",
      "cloudwatch:DescribeAlarms",

      "cloudwatch:PutDashboard",
      "cloudwatch:GetDashboard",
      "cloudwatch:DeleteDashboards",
      "cloudwatch:ListDashboards",

      "cloudwatch:TagResource",
      "cloudwatch:UntagResource",
      "cloudwatch:ListTagsForResource",

      "logs:CreateLogGroup",
      "logs:DeleteLogGroup",
      "logs:DeleteMetricFilter",
      "logs:DescribeLogGroups",
      "logs:DescribeMetricFilters",
      "logs:PutRetentionPolicy",
      "logs:DeleteRetentionPolicy",
      "logs:PutResourcePolicy",
      "logs:DeleteResourcePolicy",
      "logs:DescribeResourcePolicies",

      "logs:TagResource",
      "logs:UntagResource",
      "logs:ListTagsForResource",
      "logs:PutMetricFilter",

      "sns:CreateTopic",
      "sns:DeleteTopic",
      "sns:GetTopicAttributes",
      "sns:SetTopicAttributes",

      "sns:TagResource",
      "sns:UntagResource",
      "sns:ListTagsForResource"
    ]

    resources = ["*"]
  }

  #
  # CloudWatch Agent configuration stored in SSM Parameter Store.
  #
  statement {
    sid    = "CloudWatchAgentParameter"
    effect = "Allow"

    actions = [
      "ssm:GetParameter",
      "ssm:PutParameter",
      "ssm:DeleteParameter"
    ]

    resources = [
      "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/${local.name_prefix}/*"
    ]
  }
}

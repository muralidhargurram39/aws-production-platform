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
      "logs:DescribeLogGroups",
      "logs:PutRetentionPolicy",
      "logs:DeleteRetentionPolicy",
      "logs:PutResourcePolicy",
      "logs:DeleteResourcePolicy",
      "logs:DescribeResourcePolicies",

      "logs:TagResource",
      "logs:UntagResource",
      "logs:ListTagsForResource",

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
}

data "aws_iam_policy_document" "monitoring" {

  statement {

    sid    = "Monitoring"
    effect = "Allow"

    actions = [

      #
      # CloudWatch Alarms
      #

      "cloudwatch:PutMetricAlarm",
      "cloudwatch:DeleteAlarms",
      "cloudwatch:DescribeAlarms",

      #
      # CloudWatch Dashboards
      #

      "cloudwatch:PutDashboard",
      "cloudwatch:GetDashboard",
      "cloudwatch:DeleteDashboards",
      "cloudwatch:ListDashboards",

      #
      # CloudWatch Tags
      #

      "cloudwatch:TagResource",
      "cloudwatch:UntagResource",
      "cloudwatch:ListTagsForResource",

      #
      # CloudWatch Logs
      #

      "logs:CreateLogGroup",
      "logs:DeleteLogGroup",
      "logs:DescribeLogGroups",
      "logs:PutRetentionPolicy",
      "logs:DeleteRetentionPolicy",

      "logs:TagResource",
      "logs:UntagResource",
      "logs:ListTagsForResource",

      #
      # SNS
      #

      "sns:CreateTopic",
      "sns:DeleteTopic",
      "sns:GetTopicAttributes",
      "sns:SetTopicAttributes",

      "sns:TagResource",
      "sns:UntagResource",
      "sns:ListTagsForResource"

    ]

    resources = [
      "*"
    ]
  }
}

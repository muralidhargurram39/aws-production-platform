resource "aws_cloudwatch_log_group" "cloudtrail" {
  name              = "/aws/cloudtrail/${local.name_prefix}"
  retention_in_days = 365

  kms_key_id = var.kms_key_arn

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-cloudtrail"
    }
  )
}

data "aws_iam_policy_document" "cloudwatch_assume_role" {

  statement {

    effect = "Allow"

    principals {
      type = "Service"

      identifiers = [
        "cloudtrail.amazonaws.com"
      ]
    }

    actions = [
      "sts:AssumeRole"
    ]
  }
}

resource "aws_iam_role" "cloudwatch" {

  name = "${local.name_prefix}-cloudtrail-cloudwatch-role"

  assume_role_policy = data.aws_iam_policy_document.cloudwatch_assume_role.json

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-cloudtrail-cloudwatch-role"
    }
  )
}

data "aws_iam_policy_document" "cloudwatch" {

  statement {

    sid    = "CloudTrailCreateLogStream"
    effect = "Allow"

    actions = [
      "logs:CreateLogStream"
    ]

    resources = [
      "${aws_cloudwatch_log_group.cloudtrail.arn}:log-stream:*"
    ]
  }

  statement {

    sid    = "CloudTrailPutLogEvents"
    effect = "Allow"

    actions = [
      "logs:PutLogEvents"
    ]

    resources = [
      "${aws_cloudwatch_log_group.cloudtrail.arn}:log-stream:*"
    ]
  }
}

resource "aws_iam_role_policy" "cloudwatch" {

  name = "${local.name_prefix}-cloudtrail-cloudwatch-policy"
  role = aws_iam_role.cloudwatch.id

  policy = data.aws_iam_policy_document.cloudwatch.json
}

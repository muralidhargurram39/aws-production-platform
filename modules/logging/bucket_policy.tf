data "aws_iam_policy_document" "alb_access_logs" {
  statement {
    sid    = "AllowALBAccessLogs"
    effect = "Allow"

    principals {
      type = "Service"

      identifiers = [
        "logdelivery.elasticloadbalancing.amazonaws.com"
      ]
    }

    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.logs.arn}/alb/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
    ]
  }
}

resource "aws_s3_bucket_policy" "logs" {
  bucket = aws_s3_bucket.logs.id
  policy = data.aws_iam_policy_document.alb_access_logs.json
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "logs_bucket" {

  statement {

    sid    = "AllowALBGetBucketAcl"
    effect = "Allow"

    principals {
      type = "Service"

      identifiers = [
        "logdelivery.elasticloadbalancing.amazonaws.com"
      ]
    }

    actions = [
      "s3:GetBucketAcl"
    ]

    resources = [
      aws_s3_bucket.logs.arn
    ]
  }

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

    condition {

      test     = "StringEquals"
      variable = "s3:x-amz-acl"

      values = [
        "bucket-owner-full-control"
      ]
    }
  }

  #
  # Allow CloudTrail to verify bucket ownership
  #
  statement {

    sid    = "AWSCloudTrailAclCheck"
    effect = "Allow"

    principals {
      type = "Service"

      identifiers = [
        "cloudtrail.amazonaws.com"
      ]
    }

    actions = [
      "s3:GetBucketAcl"
    ]

    resources = [
      aws_s3_bucket.logs.arn
    ]

    condition {

      test     = "StringEquals"
      variable = "aws:SourceArn"

      values = [
        "arn:aws:cloudtrail:${var.aws_region}:${data.aws_caller_identity.current.account_id}:trail/${var.project_name}-${var.environment}-cloudtrail"
      ]
    }
  }

  #
  # Allow CloudTrail to write logs
  #
  statement {

    sid    = "AWSCloudTrailWrite"
    effect = "Allow"

    principals {
      type = "Service"

      identifiers = [
        "cloudtrail.amazonaws.com"
      ]
    }

    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.logs.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
    ]

    condition {

      test     = "StringEquals"
      variable = "s3:x-amz-acl"

      values = [
        "bucket-owner-full-control"
      ]
    }

    condition {

      test     = "StringEquals"
      variable = "aws:SourceArn"

      values = [
        "arn:aws:cloudtrail:${var.aws_region}:${data.aws_caller_identity.current.account_id}:trail/${var.project_name}-${var.environment}-cloudtrail"
      ]
    }
  }
}

resource "aws_s3_bucket_policy" "logs" {

  bucket = aws_s3_bucket.logs.id

  policy = data.aws_iam_policy_document.logs_bucket.json
}

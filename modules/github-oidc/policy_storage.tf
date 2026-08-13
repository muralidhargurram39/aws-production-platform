data "aws_iam_policy_document" "storage" {

  #
  # S3 bucket creation
  #
  # CreateBucket requires Resource="*" because the bucket does not exist
  # when IAM authorization is evaluated.
  #
  # Subsequent bucket management is restricted to this project's
  # environment/account bucket-name prefix below.
  #
  #checkov:skip=CKV_AWS_111:S3 CreateBucket requires wildcard resource scope
  #checkov:skip=CKV_AWS_356:S3 CreateBucket does not support resource-level permissions
  statement {
    sid    = "S3BucketCreate"
    effect = "Allow"

    actions = [
      "s3:CreateBucket"
    ]

    resources = ["*"]
  }

  #
  # S3 bucket management
  #
  statement {
    sid    = "S3BucketManagement"
    effect = "Allow"

    actions = [
      "s3:DeleteBucket",
      "s3:GetAccelerateConfiguration",
      "s3:GetBucketAcl",
      "s3:GetBucketCors",
      "s3:GetEncryptionConfiguration",
      "s3:GetBucketLocation",
      "s3:GetBucketLogging",
      "s3:GetBucketNotification",
      "s3:GetBucketOwnershipControls",
      "s3:GetBucketPolicy",
      "s3:GetBucketPublicAccessBlock",
      "s3:GetBucketRequestPayment",
      "s3:GetBucketTagging",
      "s3:GetBucketVersioning",
      "s3:GetBucketWebsite",
      "s3:GetLifecycleConfiguration",
      "s3:GetReplicationConfiguration",
      "s3:ListBucket",
      "s3:PutBucketCORS",
      "s3:PutBucketEncryption",
      "s3:PutBucketLogging",
      "s3:PutBucketNotification",
      "s3:PutBucketOwnershipControls",
      "s3:PutBucketPolicy",
      "s3:PutBucketPublicAccessBlock",
      "s3:PutBucketTagging",
      "s3:PutBucketVersioning",
      "s3:PutLifecycleConfiguration"
    ]

    resources = [
      "arn:aws:s3:::${var.project_name}-${var.environment}-${data.aws_caller_identity.current.account_id}-*"
    ]
  }

  #
  # S3 object management
  #
  statement {
    sid    = "S3ObjectManagement"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:PutObject",
      "s3:DeleteObject"
    ]

    resources = [
      "arn:aws:s3:::${var.project_name}-${var.environment}-${data.aws_caller_identity.current.account_id}-*/*"
    ]
  }
}

resource "aws_iam_policy" "storage" {
  name        = "${local.name_prefix}-storage-policy"
  description = "S3 storage management for the platform"
  policy      = data.aws_iam_policy_document.storage.json
}

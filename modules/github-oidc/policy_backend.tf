data "aws_iam_policy_document" "backend" {

  statement {

    sid    = "TerraformBackend"
    effect = "Allow"

    actions = [

      # S3
      "s3:GetBucketLocation",
      "s3:GetBucketVersioning",
      "s3:ListBucket",
      "s3:CreateBucket",
      "s3:DeleteBucket",
      "s3:GetBucketPolicy",
      "s3:PutBucketPolicy",
      "s3:GetBucketEncryption",
      "s3:PutEncryptionConfiguration",
      "s3:GetBucketPublicAccessBlock",
      "s3:PutBucketPublicAccessBlock",
      "s3:GetBucketOwnershipControls",
      "s3:PutBucketOwnershipControls",
      "s3:GetLifecycleConfiguration",
      "s3:PutLifecycleConfiguration",
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:GetObjectVersion",

      # DynamoDB
      "dynamodb:CreateTable",
      "dynamodb:DeleteTable",
      "dynamodb:DescribeTable",
      "dynamodb:UpdateTable",
      "dynamodb:ListTables",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem",
      "dynamodb:DescribeContinuousBackups",
      "dynamodb:UpdateContinuousBackups"
    ]

    resources = [

      "arn:aws:s3:::${var.backend_bucket_name}",

      "arn:aws:s3:::${var.backend_bucket_name}/*",

      "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${var.backend_lock_table_name}"

    ]
  }
  statement {
    sid    = "TerraformBackendKMS"
    effect = "Allow"

    actions = [
      "kms:Decrypt",
      "kms:Encrypt",
      "kms:GenerateDataKey",
      "kms:DescribeKey",
    ]

    resources = [
      var.backend_kms_key_arn
    ]
  }
  statement {
    sid    = "TerraformEC2Read"
    effect = "Allow"

    actions = [
      "ec2:DescribeManagedPrefixLists",
    ]

    resources = ["*"]
  }
}

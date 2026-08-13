data "aws_iam_policy_document" "backup" {

  #
  # Backup Vault
  #
  # Backup vault creation and account-level control-plane operations
  # require Resource="*" because the vault does not exist yet.
  #
  #checkov:skip=CKV_AWS_109:Backup vault creation/control-plane APIs require wildcard resource scope
  #checkov:skip=CKV_AWS_111:Backup vault creation/control-plane APIs require wildcard resource scope
  #checkov:skip=CKV_AWS_356:Backup vault creation/control-plane APIs require Resource=*
  statement {
    sid    = "BackupVault"
    effect = "Allow"

    actions = [
      "backup:CreateBackupVault",
      "backup:DeleteBackupVault",
      "backup:DescribeBackupVault",
      "backup:ListBackupVaults",
      "backup:PutBackupVaultAccessPolicy",
      "backup:DeleteBackupVaultAccessPolicy",
      "backup:PutBackupVaultLockConfiguration",
      "backup:DeleteBackupVaultLockConfiguration",
      "backup:TagResource",
      "backup:UntagResource",
      "backup:ListTags"
    ]

    resources = ["*"]
  }

  #
  # Backup Plans
  #
  #checkov:skip=CKV_AWS_109:Backup plan creation/control-plane APIs require wildcard resource scope
  #checkov:skip=CKV_AWS_111:Backup plan creation/control-plane APIs require wildcard resource scope
  #checkov:skip=CKV_AWS_356:Backup plan creation/control-plane APIs require Resource=*
  statement {
    sid    = "BackupPlans"
    effect = "Allow"

    actions = [
      "backup:CreateBackupPlan",
      "backup:DeleteBackupPlan",
      "backup:GetBackupPlan",
      "backup:UpdateBackupPlan",
      "backup:ListBackupPlans"
    ]

    resources = ["*"]
  }

  #
  # Backup Selections
  #
  #checkov:skip=CKV_AWS_109:Backup selection creation/control-plane APIs require wildcard resource scope
  #checkov:skip=CKV_AWS_111:Backup selection creation/control-plane APIs require wildcard resource scope
  #checkov:skip=CKV_AWS_356:Backup selection creation/control-plane APIs require Resource=*
  statement {
    sid    = "BackupSelections"
    effect = "Allow"

    actions = [
      "backup:CreateBackupSelection",
      "backup:DeleteBackupSelection",
      "backup:GetBackupSelection",
      "backup:ListBackupSelections"
    ]

    resources = ["*"]
  }

  #
  # KMS access used by AWS Backup.
  #
  statement {
    sid    = "BackupKMS"
    effect = "Allow"

    actions = [
      "kms:CreateGrant",
      "kms:RetireGrant",
      "kms:DescribeKey",
      "kms:GenerateDataKey",
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncryptFrom",
      "kms:ReEncryptTo"
    ]

    resources = [
      "arn:aws:kms:*:${data.aws_caller_identity.current.account_id}:key/*"
    ]
  }
}

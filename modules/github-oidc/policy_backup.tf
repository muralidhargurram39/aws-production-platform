data "aws_iam_policy_document" "backup" {

  #
  # Backup Vault
  #
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
}

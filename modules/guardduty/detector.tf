resource "aws_guardduty_detector" "main" {
  #checkov:skip=CKV2_AWS_3:Standalone AWS account; AWS Organizations is not used. GuardDuty detector is explicitly enabled in this account.
  enable = true

  finding_publishing_frequency = "FIFTEEN_MINUTES"
}

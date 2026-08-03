data "aws_iam_policy_document" "terraform" {

  source_policy_documents = [
    data.aws_iam_policy_document.backend.json,
    data.aws_iam_policy_document.identity.json,
    data.aws_iam_policy_document.tagging.json,
    data.aws_iam_policy_document.networking.json,
    data.aws_iam_policy_document.monitoring.json,
    data.aws_iam_policy_document.security.json,
    data.aws_iam_policy_document.governance.json,
    data.aws_iam_policy_document.backup.json,
    data.aws_iam_policy_document.cloudfront.json
  ]
}

resource "aws_accessanalyzer_analyzer" "main" {
  analyzer_name = "${var.project_name}-${var.environment}-access-analyzer"

  type = "ACCOUNT"
}

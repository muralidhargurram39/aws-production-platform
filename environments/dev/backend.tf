terraform {
  backend "s3" {
    bucket         = "aws-production-platform-tf-state-2026"
    key            = "dev/terraform.tfstate"
    region         = "ap-south-2"
    dynamodb_table = "aws-production-platform-terraform-lock"
    encrypt        = true
  }
}

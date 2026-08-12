terraform {
  backend "s3" {
    bucket = "aws-production-platform-tf-state-2026"
    key    = "bootstrap/terraform.tfstate"
    region = "ap-south-2"
  }
}

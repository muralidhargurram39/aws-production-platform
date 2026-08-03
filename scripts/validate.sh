#!/usr/bin/env bash

set -euo pipefail

echo "========================================="
echo "Terraform Local Validation"
echo "========================================="

echo
echo "==> Terraform Format"
terraform fmt -recursive

echo
echo "==> Terraform Validate"

cd environments/dev

terraform init -lock=false

terraform validate

echo
echo "==> Terraform Plan"

terraform plan -lock=false -out=tfplan

cd ../..

echo
echo "==> TFLint"

tflint --recursive

echo
echo "==> Checkov"

checkov -d .

echo
echo "========================================="
echo "Validation completed successfully."
echo "========================================="

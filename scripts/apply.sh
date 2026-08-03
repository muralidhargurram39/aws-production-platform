#!/usr/bin/env bash
set -euo pipefail

cd environments/dev

terraform apply tfplan

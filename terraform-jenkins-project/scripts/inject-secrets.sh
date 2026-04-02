#!/usr/bin/env bash
# Usage: source scripts/inject-secrets.sh <env>
# Fetches DB password from AWS Secrets Manager and exports as TF_VAR

set -euo pipefail

ENV=${1:?Usage: source inject-secrets.sh <dev|staging|prod>}
SECRET_NAME="myapp/${ENV}/db-password"

echo "[INFO] Fetching secret: ${SECRET_NAME}"
export TF_VAR_db_password=$(
  aws secretsmanager get-secret-value \
    --secret-id "${SECRET_NAME}" \
    --query SecretString \
    --output text
)

echo "[INFO] TF_VAR_db_password injected (not printed)"

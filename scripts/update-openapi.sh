#!/usr/bin/env bash
# Refresh the checked-in backend contract before regenerating Dart models.
set -euo pipefail

repo_root="$(git rev-parse --show-toplevel)"
cd "$repo_root"

spec_url="${BACKEND_OPENAPI_URL:-http://localhost:8080/openapi.json}"
spec_file="openapi/backend.swagger"
tmp_file="$(mktemp)"
trap 'rm -f "$tmp_file"' EXIT

curl --fail --silent --show-error --location "$spec_url" --output "$tmp_file"
jq -e '.openapi and (.components.schemas | type == "object")' "$tmp_file" >/dev/null
mv "$tmp_file" "$spec_file"
echo "Updated $spec_file from $spec_url"

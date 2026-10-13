#!/usr/bin/env bash
# Scans the given files for credentials. Used by the pre-commit hook and CI.
# Usage: scripts/scan-secrets.sh <file> [<file> ...]
set -uo pipefail

[[ $# -eq 0 ]] && exit 0

# Always fatal, anywhere in the repo.
hard_patterns=(
  '-----BEGIN [A-Z ]*PRIVATE KEY-----'
  'AIza[0-9A-Za-z_-]{35}'
  'AKIA[0-9A-Z]{16}'
  'ghp_[A-Za-z0-9]{36}'
  'github_pat_[A-Za-z0-9_]{20,}'
  'xox[baprs]-[A-Za-z0-9-]{10,}'
  '"type"[[:space:]]*:[[:space:]]*"service_account"'
  'eyJhbGciOi[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\.'
)

# Assignment-style secrets; skipped in tests and docs where samples are fine.
soft_patterns=(
  '(client_secret|api[_-]?key|apikey|access[_-]?key|private[_-]?key|auth[_-]?token)[[:space:]]*[:=][[:space:]]*.?[A-Za-z0-9_/+=-]{12,}'
)

status=0

for file in "$@"; do
  [[ -f "$file" ]] || continue
  grep -Iq . "$file" 2>/dev/null || continue # skip binaries

  for pattern in "${hard_patterns[@]}"; do
    if match=$(grep -nEm1 -e "$pattern" "$file"); then
      echo "Possible credential in $file:${match%%:*}" >&2
      status=1
    fi
  done

  case "$file" in
    test/*|integration_test/*|*.md|*.example|config/*.json) continue ;;
  esac

  for pattern in "${soft_patterns[@]}"; do
    if match=$(grep -nEim1 -e "$pattern" "$file"); then
      echo "Possible hard-coded secret in $file:${match%%:*}" >&2
      status=1
    fi
  done
done

if [[ $status -ne 0 ]]; then
  cat >&2 <<'EOF'

Secrets must never be committed. Use Secret Manager / GitHub secrets, and
--dart-define for build-time values. If this is a false positive, rename the
variable or commit with SKIP_HOOKS=1 and explain it in the PR.
EOF
fi

exit $status

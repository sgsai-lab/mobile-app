#!/usr/bin/env bash
# Point git at the versioned hooks. Run once per clone: `make hooks`.
set -euo pipefail

repo_root="$(git rev-parse --show-toplevel)"
cd "$repo_root"

git config core.hooksPath .githooks
chmod +x .githooks/* scripts/*.sh 2>/dev/null || true

echo "Git hooks enabled (core.hooksPath=.githooks)."
echo "Bypass once with: SKIP_HOOKS=1 git commit ..."

#!/usr/bin/env bash
# Generates the android/ and ios/ host projects the first time they are needed.
# Dart sources, tests and tooling are already in git; the platform folders are
# created by Flutter so they match the installed SDK.
set -euo pipefail

repo_root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$repo_root"

if ! command -v flutter >/dev/null 2>&1; then
  echo "flutter is not installed. See README.md → Prerequisites." >&2
  exit 1
fi

platforms=()
[[ -d android ]] || platforms+=("android")
[[ -d ios ]] || platforms+=("ios")

if [[ ${#platforms[@]} -eq 0 ]]; then
  echo "android/ and ios/ already exist, nothing to do."
  exit 0
fi

joined="$(IFS=, ; echo "${platforms[*]}")"
echo "Creating platform projects: $joined"
flutter create \
  --project-name mobile_app \
  --org com.sgsai \
  --platforms="$joined" \
  .

cat <<'EOF'

Next:
  1. Add the flavor build types - docs/flavors.md (APP-03).
  2. Drop the per-flavor Firebase config files in place (APP-04) - they are
     gitignored, fetch them from the Firebase console or Secret Manager.
  3. flutter run --flavor dev --dart-define-from-file=config/dev.json
EOF

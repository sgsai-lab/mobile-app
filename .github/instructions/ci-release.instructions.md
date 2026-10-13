---
applyTo: ".github/workflows/**,.github/dependabot.yml,.githooks/**"
description: "CI, release pipeline and git hook rules."
---
# CI, release & hooks

## Workflows

- Pin every third-party action to a commit SHA with a `# vX.Y.Z` comment. Dependabot updates them.
- Declare least-privilege `permissions:` at the top of each workflow; add job-level permissions only where needed.
- Keep the PR pipeline under 10 minutes. Linux runners for analyze/test/Android; macOS only on tags or manual dispatch — macOS minutes cost roughly 10×.
- Every job sets `timeout-minutes` and uses `concurrency` to cancel superseded PR runs (never cancel release runs).
- Fail on lint and analyzer findings, not just test failures (`--fatal-infos`).
- Build a release artifact once and promote the same artifact between tracks; never rebuild per environment.
- Secrets: only in jobs that need them, through a protected `environment:`, never `echo`ed, always removed in an `if: always()` cleanup step.
- No `pull_request_target`, no secrets exposed to workflows triggered by forks.

## Hooks (`.githooks/`, enabled by `make hooks`)

| Hook | Does | Budget |
| --- | --- | --- |
| `pre-commit` | blocked file types, secret scan, >1 MB files, `dart format` on staged files | < 2 s |
| `commit-msg` | Conventional Commits, subject ≤ 72 chars | instant |
| `pre-push` | `dart format`, `flutter analyze --fatal-infos`, `flutter test` | < 2 min |

- Hooks must be POSIX-safe `bash`, exit non-zero only on real violations, and print the exact command that fixes the problem.
- Keep `pre-commit` fast — anything slower than a couple of seconds belongs in `pre-push` or CI.
- `SKIP_HOOKS=1` is the documented escape hatch; if a bypass is used, say so in the PR.
- The same `scripts/scan-secrets.sh` runs locally and in CI, so a local pass means a CI pass.

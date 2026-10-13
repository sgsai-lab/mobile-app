# Contributing

## Setup

```bash
make setup      # dependencies + git hooks (required once per clone)
make platforms  # first run only, generates android/ and ios/
```

## Workflow

1. Pick an `APP-xx` issue and branch from `develop`:
   `git switch -c feat/<issue-number>-<short-slug>`.
2. Implement following [AGENTS.md](AGENTS.md) and the matching file in
   [.github/instructions/](.github/instructions/).
3. `make check` must pass, and the flow must work on a device in the `dev` flavor.
4. Commit with Conventional Commits and reference the issue:

   ```text
   feat(profile): show the signed-in user's profile

   Refs #12
   ```

5. Push and open a **draft** PR against `develop` using the PR template. Include
   screenshots or a recording of every UI state you changed.
6. Mark it ready once CI is green and the acceptance criteria have evidence.

## Hooks

| Hook | Runs |
| --- | --- |
| `pre-commit` | blocked file types, secret scan, large files, `dart format` on staged files |
| `commit-msg` | Conventional Commits, subject ≤ 72 characters |
| `pre-push` | `dart format`, `flutter analyze --fatal-infos`, `flutter test` |

`SKIP_HOOKS=1 git commit …` bypasses them. If you use it, say why in the PR.

## Review expectations

A PR is reviewable when it has: a focused diff, tests for new behaviour, no new
secrets or permissions, handled loading/empty/error/offline states, accessible
controls (labels, 48dp targets, text scaling), and no new analyzer findings.

---
name: implement-github-issue
description: "End-to-end workflow to implement a GitHub issue (APP-xx) in mobile-app: read issue, branch, build the feature, test on a device, commit, open PR. Use when asked to 'work on issue #N', 'implement APP-05', 'pick up the next task', or 'start the ticket'."
argument-hint: "Issue number, e.g. 5"
---

# Implement a GitHub issue

## Procedure

1. **Read the issue** — `gh issue view <N> --comments`. Extract screens, states, API endpoints, acceptance criteria and "Depends on". If a dependency is open, check whether the code already exists and tell the user before starting.
2. **Sync and branch** from `develop` (fallback `main`):

   ```bash
   git fetch origin && git switch develop && git pull --ff-only
   git switch -c <type>/<N>-<short-slug>   # feat/5-design-system, fix/12-token-refresh
   ```

3. **Plan** — list the files to add/change under `lib/features/<feature>/{domain,data,presentation}`. Use sibling skills:
   - New screen or feature → `flutter-feature-module`
   - New backend call → `api-client-integration`
   - Tests → `widget-test-suite`
   - Auth, tokens, storage, permissions, new plugin → `mobile-security-review` **before** opening the PR
   - Store build or flavor work → `mobile-release`
4. **Implement** in small steps following [AGENTS.md](../../../AGENTS.md) and `.github/instructions/*`. New build-time values go in all three `config/*.json` files.
5. **Verify**:

   ```bash
   make check                       # format + analyze + tests
   make run FLAVOR=dev              # exercise the flow on a device/emulator
   ```

   Check loading, error, offline and empty states, dark mode and 200% text scale. Fix every failure; never skip a test to go green.
6. **Tick the issue checklist** for what is actually done (`gh issue edit` or a comment).
7. **Commit** with conventional commits, small and focused:
   `feat(profile): show the signed-in user's profile` with body `Refs #<N>`.
8. **Push and open a draft PR** (confirm with the user before pushing):

   ```bash
   git push -u origin HEAD
   gh pr create --draft --base develop --title "<type>(<scope>): <summary>" --body-file <tmp>
   ```

   PR body follows `.github/pull_request_template.md`: summary, `Closes #<N>`, acceptance criteria with evidence, screenshots of each state, security notes, follow-ups.

## Done when

- Every acceptance criterion has evidence (test, screenshot or recording) in the PR.
- `make check` passes and the flow works on a real device in the `dev` flavor.
- No new secrets, permissions, logs of sensitive data, or unhandled async states.

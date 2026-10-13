---
name: mobile-security-review
description: "Security review for mobile changes touching auth, tokens, storage, logging, permissions, WebViews, deep links or new plugins. Use before opening a PR that changes any of those, and when reviewing one."
---

# Mobile security review

Run this before opening the PR. Anything shipped in the binary is public; anything stored insecurely is one rooted device away from disclosure.

## Checklist

### Secrets & build artefacts
- [ ] No API keys, service accounts, keystores, `.p12`, `.mobileprovision` or Firebase config in git (`git diff --stat` and `./scripts/scan-secrets.sh $(git ls-files)`).
- [ ] Build-time values come from `config/*.json` via `AppConfig`; none of them is a credential.
- [ ] Release signing material only reaches CI through a protected environment and is deleted after the build.

### Tokens & identity
- [ ] Firebase ID/refresh tokens remain inside the FirebaseAuth SDK; the app never copies them into its own storage.
- [ ] No token in logs, analytics, crash reports, URLs, screenshots or error messages.
- [ ] Firebase token attachment and one forced refresh stay inside `AuthInterceptor`; then sign out locally and rely on backend Firebase revocation.
- [ ] Sign-out clears every token and cached personal data, and revokes server-side.
- [ ] Identity is never taken from a request field — Firebase UID is verified by the backend; profile comes from `/users/me`.

### Transport
- [ ] HTTPS everywhere outside `dev`; no cleartext traffic, no ATS exceptions, no certificate validation disabled.
- [ ] No sensitive data in query strings; it goes in the body or headers.

### Data at rest & on screen
- [ ] No personal data in `SharedPreferences`, plain files, or logs.
- [ ] Password/secret fields use `obscureText`, disable autocorrect and suggestions.
- [ ] Clipboard, screenshots and background snapshots considered for sensitive screens.

### Platform surface
- [ ] New permissions justified, minimal, requested in context, and documented for the privacy policy.
- [ ] Deep links validate their input; no navigation to arbitrary URLs.
- [ ] WebViews (if any) disable JavaScript unless required, allowlist origins, and never receive tokens.
- [ ] New plugins reviewed: maintained, scoped permissions, no analytics side effects.

### Robustness
- [ ] Server responses are validated (`fromJson` with typed casts); the client never trusts client-side authorization decisions.
- [ ] Release builds strip debug logging and enable R8/ProGuard.
- [ ] A force-upgrade path exists or has an issue before the first store release.

## Output

Report findings as: **severity** (blocker / should-fix / note), file and line, concrete fix. Fix every blocker before requesting review and mention the review in the PR's security notes.

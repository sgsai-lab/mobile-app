# SGS AI app: client hub brief (APP-11)

Decided 2026-10-27 by the founder ([home ADR-002](https://github.com/sgsai-lab/home/blob/main/docs/adr/0002-firestore-first-data-platform.md)). Answers the questions in APP-01.

## 1. User

A **staff member of an organisation that runs a project with SGS AI Technology** (for example a school programme lead or a company operations manager) who has been invited to that organisation's workspace. Staff only: students and the client's own customers never get accounts here; they use the client's apps directly.

## 2. Problem

The apps SGS builds for a client live at separate addresses, and project status lives in emails. Nobody on the client side has one place that answers "where is our app, and what is SGS doing next?"

## 3. Core journey (one sentence)

**Sign in → pick my organisation → tap the app or service I need → it opens.**

## 4. First 60 seconds

Sign in with the invited email (password, Google or Apple), see the organisation's apps and current project status, tap an app.

## 5. Why AI?

Version 1 needs none. The hub is the distribution channel for the AI-powered services SGS builds; we do not force AI into the shell.

## 6. Out of scope

- Rendering client apps inside this app (they open in the system browser or their store app)
- Chat, ticketing, payments, contracts
- Accounts for students or a client's customers
- Editing projects or uploading files on mobile (web hub)
- Offline editing
- Push notifications in the first release (APP-17, stretch)

## 7. Success metric

**Weekly launches per active client** from the app (`launch_events` with `source` `android` or `ios`), target ≥ 3.

## Journeys

| Journey | Steps |
| --- | --- |
| (a) Invited member, first run | Invitation email → web sign-up (verifies the address) → install app → sign in → workspace opens on the invited organisation |
| (b) Returning member launches an app | Open app (session restored from secure storage) → tap app tile → server issues a 60-second launch link → system browser opens the client app |
| (c) Member checks progress | Tap a project → milestones (overdue highlighted), linked apps, deliverables (opened through 1-hour signed links) |
| (d) Member of two organisations | Workspace selector → contents reload → choice saved to the profile, shared with the web hub |
| (e) Removed or not yet invited | "No access" or "No workspace yet" explanation with a way to contact SGS; the cached copy of a removed workspace is deleted |
| (f) Shared link | `https://www.sgsaitechnology.com/go/{slug}` or `sgsai://go/{slug}` opens the app (signing in first if needed), then the client app |
| (g) No connection | Last workspace snapshot (names and links only) renders with an "offline" notice; opening an app says "you are offline" |

## Screens

```text
+----------------------------------+   +----------------------------------+
| Riverside Academy        [Exit]  |   | < Year 9 science portal          |
| [logo] Education · You are admin |   | Education · Year 9 · 2026/27     |
| [ Workspace: Riverside ▼ ]       |   | In progress · Target 15 Jul 2027 |
| Apps and services                |   | Milestones                       |
| [LP] Learning Portal  Live   ↗   |   | ✓ Needs analysis      1 Sep 2026 |
| [OP] Old Portal       Retired ⦸  |   | ○ Pilot cohort  Overdue 1 Oct    |
| Projects                         |   | Apps from this project           |
| In progress · Year 9 science ... |   | Deliverables  scope.pdf  [↓]     |
| Team: Hana Head · Admin          |   +----------------------------------+
+----------------------------------+
```

## Dependencies

API: sgsai-lab/home `/api/v1` (`docs/api.md`): auth with `X-Client: mobile`, `/users/me`, `/clients`, `/projects`, `/products`, `/products/{id}/launch-token`, `/products/by-slug/{slug}`, `/assets`. Deep links need `ANDROID_CERT_SHA256` and `APPLE_TEAM_ID` on the home service (after APP-09 signing).

## Dates

Internal build Week 7 (December 2026); private beta Q1 2027.

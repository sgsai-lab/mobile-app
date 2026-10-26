# SGS AI Services App

## Product concept

A simple sign-in hub that shows the user's available SGS AI progressive web apps
and opens the selected service.

## User and problem

**Working assumption:** a person who already uses, or has been granted access to,
one or more SGS AI PWAs. Today they need to remember separate URLs and discover
which services are available. The founder still needs to confirm the exact user
role and validate that this is a painful enough problem to justify a separate app.

## Core journey

A user signs in once, sees the available SGS AI PWAs in one directory, and opens
the service they need.

In the first 60 seconds the user signs in, sees the service list, and can open a
service link. Firebase Auth supplies identity; the backend maps the verified
Firebase UID to its local user record. AI is not part of this product: removing
AI changes nothing in the MVP.

## Journeys

1. **First visit:** sign in with Firebase email/password → load the profile and
   service catalog → tap a service → open its HTTPS PWA URL.
2. **Return visit:** Firebase restores the session → show the service catalog →
   refresh the list or open another PWA.
3. **Offline recovery:** show the offline banner → keep the last usable screen
   visible → remove the banner when connectivity returns → allow the user to retry.

## MVP scope

- Firebase email/password sign-in and sign-out.
- One authenticated directory of Remote Config services.
- Open service destinations in the platform browser/PWA handler.
- Loading, empty, error, offline and retry states.

## Out of scope

- AI assistant or generated recommendations.
- Rebuilding each PWA inside the mobile app.
- Native feature parity with each service.
- User-created service links or catalog administration in the app.
- Search, folders, favorites, push notifications and analytics funnels.
- Onboarding carousel or bottom navigation before multiple app destinations exist.
- Phone OTP or social sign-in until the product team chooses providers.

## Success signal

**Catalog-ready sign-in rate:** the percentage of successful sign-ins that render
the service directory within 60 seconds. Instrumentation and a numeric target need
founder approval; no analytics SDK is enabled yet.

## Initial sample catalog

These are placeholders only, not real SGS AI service names or production URLs:

- WorkDesk — `https://work.google.com`
- LearnHub — `https://learn.google.com`
- HelpDesk — `https://support.google.com`

Replace them in Firebase Remote Config key `pwa_services` before distributing a
build to users.

## Low-fidelity layout

```text
+----------------------------------+
| SGS AI                    [Exit] |
| Ada User · user@example.com      |
+----------------------------------+
| Your services                    |
| +------------------------------+ |
| | WorkDesk          [Open ↗]   | |
| | Team operations workspace.   | |
| +------------------------------+ |
| +------------------------------+ |
| | LearnHub          [Open ↗]   | |
| | Courses and resources.       | |
| +------------------------------+ |
| +------------------------------+ |
| | HelpDesk          [Open ↗]   | |
| | Support requests.            | |
| +------------------------------+ |
+----------------------------------+
```

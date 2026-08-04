---
title: iOS Deployment
description: CocoaPods, Automatic signing team VGTWPL7QUR, and AuthKey security concern.
tags: [cityzens, deployment, ios, signing]
created: 2026-08-04
updated: 2026-08-04
owner: Cityzens Engineering
status: verified
---

# iOS Deployment

> Back to [[Home]] · [[Deployment/Index|Deployment]]

## Pods

```bash
make pod-install
# or: cd ios/ && pod install
```

Open `ios/Runner.xcworkspace` (not `.xcodeproj`) for Archive.

Build:

```bash
flutter build ios --release
```

Then Archive / distribute from Xcode.

## Signing

Code-verified in `ios/Runner.xcodeproj/project.pbxproj`:

| Setting | Value |
|---|---|
| `CODE_SIGN_STYLE` | Automatic |
| `DEVELOPMENT_TEAM` | `VGTWPL7QUR` |

Entitlements variants: `Runner.entitlements`, `RunnerDebug.entitlements`, `RunnerProfile.entitlements`.

## Security concern — AuthKey at repo root

An Apple AuthKey `.p8` file (`AuthKey_J49ACV752S.p8`) is present at the **repository root**.

> [!warning] Do not treat as safe
> `.p8` AuthKeys are credentials. They should not live in an app source tree that is shared or cloned broadly. Rotate/revoke if exposed; store in a secrets manager; ensure `.gitignore` / vault policy excludes them from future commits.

## Related

- [[Versioning]] — iOS marketing version may lag `pubspec`
- [[Release Checklist]]
- [[Troubleshooting/Index|Troubleshooting]]

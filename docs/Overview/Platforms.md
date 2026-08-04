---
title: Platforms
description: Supported and scaffold platforms for Cityzens.
tags: [cityzens, overview, platforms]
created: 2026-08-04
updated: 2026-08-04
owner: Cityzens Engineering
status: verified
---

# Platforms

| Platform | Production | App ID | Notes |
|---|---|---|---|
| Android | Yes | `com.tcs.tcsapp` | `google-services.json` under `android/app/` |
| iOS | Yes | `com.tcs.tcsapp` | `GoogleService-Info.plist` under `ios/Runner/` |
| Web | Limited | — | `kIsWeb` branches skip FCM background registration |
| Desktop | No | — | `linux/`, `macos/`, `windows/` scaffolds only |

> [!warning] Verification Required
> Confirm store listing IDs and team access with the product owner; do not assume from code alone beyond bundle/application IDs above.

## Related

- [[Overview/Index|Overview]] · [[Deployment/Index|Deployment]] · [[Firebase/Index|Firebase]]

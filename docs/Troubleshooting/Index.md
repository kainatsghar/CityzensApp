---
title: Troubleshooting Index
description: Common Cityzens failures — CocoaPods, baseUrl, FCM, signing, and codegen.
tags: [cityzens, troubleshooting, index]
created: 2026-08-04
updated: 2026-08-04
owner: Cityzens Engineering
status: verified
---

# Troubleshooting

> Back to [[Home]] · [[Handover/Vendor Guide|Vendor Guide]] · [[Development/Index|Development]]

## CocoaPods / iOS build

| Symptom | Try |
|---|---|
| Missing pods / module not found | `make pod-install` |
| Stale lock / conflict | `make reset-pod` or `make reset-pod-cache` |
| Slow / flaky repo update | `make fast-pod` (no repo update) |
| Opened wrong project | Use `ios/Runner.xcworkspace`, not `.xcodeproj` |

See [[Development/Makefile|Makefile]] · [[Deployment/iOS|iOS]].

## Wrong API / baseUrl

| Check | Detail |
|---|---|
| Active host | `AppConstants.baseUrl` → Test by default |
| Live not applying | Must edit `app_constants.dart`; Remote Config **not** initializing |
| `make test-apk` | Does **not** flip env — `CITYZENS_ENV` unused in Dart |

See [[Development/Environments|Environments]] · [[Diagrams/Configuration Flow|Configuration Flow]].

## FCM / notifications

| Symptom | Likely cause |
|---|---|
| No push on debug token refresh | `FcmTokenRefreshService` skips API in `kDebugMode` |
| No foreground banners | `notifications_enabled` pref false; check permissions |
| Tap does nothing | Payload needs `route` or `openUrl`; `Challan` route commented out |
| Missing GoogleService files | Ensure plist / `google-services.json` present |

See [[Flows/Notification Flow|Notification Flow]] · [[Firebase/Messaging|Messaging]].

## Signing

| Platform | Issue | Fix direction |
|---|---|---|
| Android | Release unsigned / fails | Ensure `android/key.properties` exists and `storeFile` resolves to `keyStore/key.jks` |
| iOS | Team / provisioning | Automatic signing; team `VGTWPL7QUR` |
| iOS | AuthKey confusion | Root `.p8` is not for day-to-day Xcode Automatic signing; treat as secret |

See [[Deployment/Android|Android]] · [[Deployment/iOS|iOS]].

## Codegen / Freezed / assets

| Symptom | Try |
|---|---|
| Missing `*.g.dart` / `*.freezed.dart` | `make generate` |
| Conflicting outputs | Same target uses `--delete-conflicting-outputs` |
| Asset refs stale | `make gen` (`fluttergen`) |
| After clean | `make clean` then `make get` && `make generate` |

## Product gaps (not bugs)

- Complaint submit shows success **without** API — [[Flows/Complaint and Query Flow|Complaint Flow]]
- Pay flag always true; Firestore feature config unused — [[Flows/Fee and Payment Flow|Fee Flow]]
- iOS `pbxproj` version may lag pubspec — [[Deployment/Versioning|Versioning]]

## Related

- [[Deployment/Release Checklist|Release Checklist]]
- [[Audit/Index|Audit]]

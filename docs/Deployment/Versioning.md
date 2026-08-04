---
title: Versioning
description: Canonical pubspec 2.0.0+89 versus stale iOS pbxproj MARKETING_VERSION 1.13.1.
tags: [cityzens, deployment, versioning]
created: 2026-08-04
updated: 2026-08-04
owner: Cityzens Engineering
status: verified
---

# Versioning

> Back to [[Home]] · [[Deployment/Index|Deployment]]

## Canonical (Dart / Flutter)

| Source | Value |
|---|---|
| `pubspec.yaml` `version` | **`2.0.0+89`** |
| `AppConstants.appVersion` | `2.0.0` (used by `Upgrader` min version) |

Android `versionName` / `versionCode` come from Flutter (`flutter.versionName` / `flutter.versionCode`) in `android/app/build.gradle`.

## Stale iOS project settings

In `ios/Runner.xcodeproj/project.pbxproj` (Runner configs):

| Key | Observed value |
|---|---|
| `MARKETING_VERSION` | `1.13.1` |
| `CURRENT_PROJECT_VERSION` | `87` |

These lag `pubspec` **2.0.0+89**. Before App Store upload, align Xcode marketing/build numbers with the intended release (or confirm Flutter tooling overrides them on archive).

README badges may also show older versions — prefer `pubspec.yaml` as SSOT for the Flutter package.

## Related

- [[Release Checklist]]
- [[Deployment/iOS|iOS]]
- [[Deployment/Android|Android]]

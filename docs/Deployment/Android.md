---
title: Android Deployment
description: Release APK and App Bundle with keyStore/key.jks via android/key.properties.
tags: [cityzens, deployment, android, signing]
created: 2026-08-04
updated: 2026-08-04
owner: Cityzens Engineering
status: verified
---

# Android Deployment

> Back to [[Home]] · [[Deployment/Index|Deployment]]

Application id: `com.tcs.tcsapp` (`android/app/build.gradle`).

## Build commands

| Goal | Command |
|---|---|
| App Bundle (Play Store) | `make appbundle` or `flutter build appbundle` |
| Release APK | `make apk` or `flutter build apk --release` |

## Signing (no secret values)

Release signing is configured in `android/app/build.gradle`:

1. Loads `android/key.properties` if present.
2. Reads `keyAlias`, `keyPassword`, `storeFile`, `storePassword`.
3. Applies `signingConfigs.release` to the release build type.
4. If `key.properties` is missing, prints a warning (release signing will fail/incomplete).

### Expected layout (code-verified)

| Artifact | Role |
|---|---|
| `android/key.properties` | Points at keystore (do **not** commit secrets to public docs) |
| `keyStore/key.jks` | Keystore file referenced by `storeFile` in this workspace |

Never paste passwords, aliases’ private material, or full property values into documentation. Keep `key.properties` and `.jks` out of shared logs.

Release also enables minify + shrink resources + ProGuard rules.

## Related

- [[Versioning]]
- [[Release Checklist]]
- [[Development/Makefile|Makefile]]

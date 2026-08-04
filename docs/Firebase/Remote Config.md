---
title: Firebase Remote Config
description: Remote Config implementation exists but _initRemoteConfig is commented out; apiBaseUrl key.
tags: [cityzens, firebase, remote-config]
created: 2026-08-04
updated: 2026-08-04
owner: Cityzens Engineering
status: verified
---

# Remote Config

> Back to [[Home]] · [[Firebase/Index|Firebase]] · [[Flutter/Lifecycle|Lifecycle]] · [[Flutter/Networking|Networking]] · [[Diagrams/Master Architecture|Master Architecture]]

Source: `lib/services/InitServices/firebase_master.dart`, `lib/utils/app_constants.dart`.

## Implemented but not started

`FirebaseMaster.initialize` runs:

```dart
await Future.wait([
  _initCrashlytics(),
  _initAnalytics(),
  // _initRemoteConfig(),
  _initFCMListeners(),
]);
```

`_initRemoteConfig` **exists** but its call is **commented out**. Status key `remoteConfig` therefore remains unset/`false` under normal bootstrap.

## What `_initRemoteConfig` would do

1. `RemoteConfigSettings`: fetch timeout 20s, minimum fetch interval 5 minutes.
2. Defaults: `{'apiBaseUrl': AppConstants.apiBaseURL}`.
3. Apply cached/default keys via `_applyRemoteConfig`.
4. `fetchAndActivate`, then apply again.
5. Subscribe to `onConfigUpdated` → activate → apply updated keys.
6. Set `_status['remoteConfig'] = true`.

## `apiBaseUrl` apply logic

When key `apiBaseUrl` is present:

- Read string; must start with `http://` or `https://`.
- Strip trailing `/api` or `/api/`.
- Assign:
  - `AppConstants.baseUrl = clean`
  - `AppConstants.apiBaseURL = '$clean/api/'`
- Invalid value → Crashlytics `recordError`.

Comment in `AppConstants` notes Remote Config key name **`apiBaseUrl`** (and historically referenced live base URL comments).

## Current runtime base URL

While Remote Config init is disabled, the app uses the compile-time `AppConstants` assignment (`baseUrl = apiTestBaseURL`). See [[Flutter/Networking|Networking]].

## Package

`firebase_remote_config` in `pubspec.yaml`.

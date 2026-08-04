---
title: Firebase Crashlytics
description: Crashlytics collection, FlutterError hook, non-fatal recording, and user custom keys.
tags: [cityzens, firebase, crashlytics]
created: 2026-08-04
updated: 2026-08-04
owner: Cityzens Engineering
status: verified
---

# Crashlytics

> Back to [[Home]] · [[Firebase/Index|Firebase]] · [[Flutter/Analytics and Logging|Analytics and Logging]] · [[Diagrams/Master Architecture|Master Architecture]]

Sources: `lib/services/InitServices/firebase_master.dart`, `lib/services/FirebaseServices/app_analytics_service.dart`.

## Initialization (`FirebaseMaster._initCrashlytics`)

- `FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true)`
- `FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError`
- Sets status map `crashlytics: true` on success

## Non-fatal errors

`FirebaseMaster.recordNonFatal(error, stack)` → `recordError` when Crashlytics status is true.

Callers include:

- `AppInitializer.bootstrapAll` catch
- Failed Analytics / FCM / Remote Config init paths inside `FirebaseMaster`

Invalid Remote Config `apiBaseUrl` also calls `recordError` with a string message (when Remote Config apply runs).

## User context

`AppAnalyticsService.setUserProperties` / `clearUserProperties` set Crashlytics:

- `setUserIdentifier` (user id or cleared to `''`)
- Custom keys: `user_type`, `device_type`, `center_name`, `region_name`, `class_section`

## Package

`firebase_crashlytics` in `pubspec.yaml`.

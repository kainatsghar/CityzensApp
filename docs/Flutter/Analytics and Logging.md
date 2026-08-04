---
title: Flutter Analytics and Logging
description: AppAnalyticsService, Crashlytics user keys, FirebaseAnalyticsObserver, dart:developer log usage.
tags: [cityzens, flutter, analytics, logging, crashlytics]
created: 2026-08-04
updated: 2026-08-04
owner: Cityzens Engineering
status: verified
---

# Analytics and Logging

> Back to [[Home]] · [[Flutter/Index|Flutter]] · [[Firebase/Analytics|Firebase Analytics]] · [[Firebase/Crashlytics|Crashlytics]] · [[Diagrams/Master Architecture|Master Architecture]]

## `AppAnalyticsService`

Source: `lib/services/FirebaseServices/app_analytics_service.dart`.

| Method | Behavior |
|---|---|
| `logLogin` | `FirebaseAnalytics.logLogin` + `setUserProperties` |
| `logLogout` | event `logout` + `clearUserProperties` |
| `logFeatureAccess` | event `feature_accessed` with `feature_name` |
| `logResultPdfEvent` | events named `result_pdf_$eventName` (stage / error_type / byte_count; no PII/URLs per comment) |
| `setUserProperties` | Analytics userId + properties; Crashlytics user id + custom keys |
| `clearUserProperties` | Clears Analytics/Crashlytics identity fields |

User properties / Crashlytics keys set on login: `user_type`, `device_type`, `center_name`, `region_name`, `class_section`.

Called from `LoginProvider` after successful login (`logLogin`).

## Related analytics

- `AdAnalyticsService` (`lib/services/FirebaseServices/ad_analytics_service.dart`) — ad impression/click events via `FirebaseAnalytics` + `dart:developer` `log`.
- `FirebaseAnalyticsObserver` from `FirebaseMaster` attached to `MaterialApp.navigatorObservers` on non-web (automatic screen tracking).

## Crashlytics

Initialized in `FirebaseMaster._initCrashlytics`:

- `setCrashlyticsCollectionEnabled(true)`
- `FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError`
- `recordNonFatal` used from bootstrap failures and init catch blocks

Deep dive: [[Firebase/Crashlytics|Crashlytics]].

## `dart:developer` `log`

Used for debug request/response and domain logging, including:

- `ApiBaseHelper` (URL, headers, body, response) when `kDebugMode`
- `FeatureConfigRepository`, `StudentSubjectService`, `AdAnalyticsService`, challan payment WebView URL, result PDF services

Separately, `AppInitializer` / `PushNotifications` / `FirebaseMaster` use `debugPrint` in debug mode.

## See also

- [[Firebase/Analytics|Firebase Analytics]]
- [[Firebase/Messaging|Messaging]] (FCM, not Analytics)

---
title: Firebase Analytics
description: Analytics collection enablement, observer, AppAnalyticsService, and AdAnalyticsService.
tags: [cityzens, firebase, analytics]
created: 2026-08-04
updated: 2026-08-04
owner: Cityzens Engineering
status: verified
---

# Analytics

> Back to [[Home]] · [[Firebase/Index|Firebase]] · [[Flutter/Analytics and Logging|Analytics and Logging]] · [[Diagrams/Master Architecture|Master Architecture]]

Sources: `lib/services/InitServices/firebase_master.dart`, `lib/services/FirebaseServices/app_analytics_service.dart`, `lib/services/FirebaseServices/ad_analytics_service.dart`, `lib/main.dart`.

## Initialization (`FirebaseMaster._initAnalytics`)

1. Checks `FirebaseAnalytics.instance.isSupported()`.
2. If supported: `setAnalyticsCollectionEnabled(true)`.
3. Creates `FirebaseAnalyticsObserver(analytics: analytics)`.
4. Sets status `analytics: true`.

Observer is exposed as `AppInitializer.analyticsObserver` and attached to `MaterialApp.navigatorObservers` when **not** web.

## App events (`AppAnalyticsService`)

| Event / API | Name / notes |
|---|---|
| Login | `logLogin(loginMethod:)` |
| Logout | custom event `logout` |
| Feature | `feature_accessed` + `feature_name` |
| Result PDF funnel | `result_pdf_$eventName` |
| User properties | `user_type`, `device_type`, `center_name`, `region_name`, `class_section` + `setUserId` |

## Ads (`AdAnalyticsService`)

Separate helper for promotion/ad impression and click logging via `FirebaseAnalytics` (and `dart:developer` `log`). Position enum: `launchPage`, `launchDialog`, `homeCarousel`.

## Package

`firebase_analytics` in `pubspec.yaml`.

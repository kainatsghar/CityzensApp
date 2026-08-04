---
title: Firebase Index
description: Product matrix for Firebase usage in the Cityzens Flutter client.
tags: [cityzens, firebase, index]
created: 2026-08-04
updated: 2026-08-04
owner: Cityzens Engineering
status: verified
---

# Firebase

> Back to [[Home]] · [[Diagrams/Master Architecture|Master Architecture]]

Firebase project id (from `lib/firebase_options.dart`): **`thecityschoolapp`**.

Core init: `AppInitializer.ensureCoreInitialized` → `Firebase.initializeApp`. Product bootstrap: `FirebaseMaster.initialize` (see [[Flutter/Lifecycle|Lifecycle]]).

## Product matrix

| Product | Package(s) | Init / code path | Doc |
|---|---|---|---|
| **Core** | `firebase_core` | `ensureCoreInitialized` | — |
| **Messaging (FCM)** | `firebase_messaging`, `flutter_local_notifications` | `PushNotifications` + `_initFCMListeners` | [[Firebase/Messaging\|Messaging]] |
| **Crashlytics** | `firebase_crashlytics` | `_initCrashlytics` | [[Firebase/Crashlytics\|Crashlytics]] |
| **Analytics** | `firebase_analytics` | `_initAnalytics` + `AppAnalyticsService` | [[Firebase/Analytics\|Analytics]] |
| **Firestore** | `cloud_firestore` | Repositories (e.g. FeatureConfig, Promotion) — not gated by `FirebaseMaster` status map | [[Firebase/Firestore\|Firestore]] |
| **Remote Config** | `firebase_remote_config` | Implementation exists; **`_initRemoteConfig()` call commented out** | [[Firebase/Remote Config\|Remote Config]] |

`FirebaseMaster` status keys: `crashlytics`, `analytics`, `fcm`, `remoteConfig` (remoteConfig stays false while init is commented out).

## Subpages

- [[Firebase/Messaging|Messaging]]
- [[Firebase/Crashlytics|Crashlytics]]
- [[Firebase/Analytics|Analytics]]
- [[Firebase/Firestore|Firestore]]
- [[Firebase/Remote Config|Remote Config]]

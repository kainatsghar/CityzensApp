---
title: Firebase Cloud Messaging
description: PushNotifications, FCM token RefreshToken API, and tap routing for Diary, Classwork, routes, openUrl.
tags: [cityzens, firebase, fcm, messaging, push]
created: 2026-08-04
updated: 2026-08-04
owner: Cityzens Engineering
status: verified
---

# Messaging

> Back to [[Home]] · [[Firebase/Index|Firebase]] · [[Diagrams/Master Architecture|Master Architecture]]

Sources: `lib/services/InitServices/push_notifications.dart`, `lib/services/InitServices/firebase_master.dart`, `lib/main.dart`, `lib/services/FCMTokenRefresh/fcm_token_refresh_service.dart`, `lib/services/Login/login_service.dart`.

## Components

| Piece | Role |
|---|---|
| Background handler in `main.dart` | `ensureCoreInitialized` + `showFromBackgroundSafe` |
| `FirebaseMaster._initFCMListeners` | `onMessage`, `onMessageOpenedApp`, `getInitialMessage` |
| `PushNotifications.init` | Local notifications plugin, permissions, foreground presentation, duplicate listeners |

Android channel: id `cityzens_notifications`, name `Cityzens Notifications`. Icon: `ic_notification`.

User toggle: SharedPreferences key `notifications_enabled` (default `true`); foreground display respects `isEnabled()`.

## FCM token → backend `RefreshToken`

`FcmTokenRefreshService.refreshToken`:

1. Requests notification permission.
2. Obtains FCM / APNS tokens (iOS delay + APNS then FCM).
3. **In `kDebugMode`, returns `false` before calling the API.**
4. Builds `LoginRequest` from `LocalDataProvider.userData` (username, userType, tokens).
5. `ApiBaseHelper.httpPostRequest("RefreshToken", body: …)`.
6. Returns `response['Status'] ?? false`.

Login also collects FCM tokens and sends them on `Auth` (see [[Backend/Screen API Maps|Screen API Maps]]).

## Tap / payload routing

`handleNotificationTap` / local notification response:

1. If `data['route']` present → `_handlePayload(route, extras: data)`.
2. Else if `openUrl` present → `HelperFunction.launchURL`.
3. Local payload may also be a bare URL (`http…`) → `_handleNotificationLink`.

### `_handlePayload` switch

| `route` value | Action |
|---|---|
| `Diary` | `AppNavigation.navigateTo(studentDiaryRoute)` |
| `Classwork` | `AppNavigation.navigateTo(studentAssignmentRoute)` |
| other | If `AppNavRoutes.isRouteAvailable(route)` → `navigateTo(route, arguments: extras)`; else log unknown |
| `Challan` | **Commented out** (would have opened fee challans) |

Foreground display payload prefers `message.data['route'] ?? message.data['openUrl']`.

## Related

- [[Flutter/Routing|Routing]] — named routes / no deep-link package
- [[Flutter/Lifecycle|Lifecycle]] — background isolate init

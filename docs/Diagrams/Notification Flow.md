---
title: Notification Flow
description: FCM foreground/background/terminated handling and payload routing via PushNotifications.
tags: [cityzens, diagrams, fcm, notifications]
created: 2026-08-04
updated: 2026-08-04
owner: Cityzens Engineering
status: verified
---

# Notification Flow

> Back to [[Home]] · [[Diagrams/Index|Diagrams]] · [[Architecture/Dependency Injection|DI]]

Firebase Cloud Messaging + local notifications. No OS deep-link scheme — tap routing is **payload-driven** only ([[Diagrams/Deep Link Flow|Deep Link Flow]]).

## Mermaid

```mermaid
flowchart TB
  subgraph Init
    Main["main()"]
    Core["AppInitializer.ensureCoreInitialized"]
    Boot["AppInitializer.bootstrapAll"]
    FM["FirebaseMaster._initFCMListeners"]
    PN["PushNotifications.instance.init"]
    Main --> Core
    Main -->|unawaited| Boot
    Boot --> FM
    Boot --> PN
    Main -->|onBackgroundMessage| BGH["_firebaseMessagingBackgroundHandler"]
    BGH --> Core
    BGH --> BGShow["push.showFromBackgroundSafe"]
  end

  subgraph Delivery
    FG["onMessage · foreground"]
    BGOpen["onMessageOpenedApp"]
    Term["getInitialMessage · terminated"]
    Local["FlutterLocalNotificationsPlugin.show"]
    FG --> ShowFG["showFromForegroundMessage"]
    ShowFG --> Local
    BGShow --> Local
    FM --> FG
    FM --> BGOpen
    FM --> Term
    PN --> FG
    PN --> BGOpen
    PN --> Term
  end

  subgraph Tap
    TapFCM["handleNotificationTap RemoteMessage"]
    TapLocal["onDidReceiveNotificationResponse"]
    Route{"data.route?"}
    URL{"data.openUrl?"}
    Alias{"Diary / Classwork / isRouteAvailable"}
    Nav["AppNavigation.navigateTo"]
    Launch["HelperFunction.launchURL"]
    BGOpen --> TapFCM
    Term --> TapFCM
    TapLocal --> Route
    TapFCM --> Route
    Route -->|Yes| Alias --> Nav
    Route -->|No| URL -->|Yes| Launch
  end
```

## Payload contract

| Key | Behavior | Evidence |
|---|---|---|
| `route` | Navigate; aliases `Diary` → `studentDiaryRoute`, `Classwork` → `studentAssignmentRoute`; else `AppNavRoutes.isRouteAvailable` | `push_notifications.dart` `_handlePayload` |
| `openUrl` | External browser / launch URL | same |
| Local `payload` | Same route string or `http…` link | `onDidReceiveNotificationResponse` |

`Challan` route case is **commented out** in source.

User preference: SharedPreferences `notifications_enabled` (default `true`); foreground show respects `isEnabled()`.

## Key files

| File | Role |
|---|---|
| `lib/main.dart` | Background handler registration |
| `lib/services/InitServices/app_initializer.dart` | Bootstrap |
| `lib/services/InitServices/firebase_master.dart` | FCM stream listeners |
| `lib/services/InitServices/push_notifications.dart` | Local plugin + tap routing |

## Related pages

- [[Diagrams/Deep Link Flow|Deep Link Flow]] · [[Diagrams/Startup Flow|Startup Flow]]
- [[Architecture/Navigation|Navigation]] · [[Firebase/Messaging|Messaging]]

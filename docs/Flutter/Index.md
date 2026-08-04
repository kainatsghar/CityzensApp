---
title: Flutter Client Index
description: Index of Flutter runtime, routing, networking, storage, theme, widgets, errors, and analytics docs.
tags: [cityzens, flutter, index]
created: 2026-08-04
updated: 2026-08-04
owner: Cityzens Engineering
status: verified
---

# Flutter Client

> Back to [[Home]] · [[Diagrams/Master Architecture|Master Architecture]]

This section documents the Flutter client (`package: tcs_app`) as implemented under `lib/`.

## Subpages

| Page | Topic |
|---|---|
| [[Flutter/Lifecycle\|Lifecycle]] | `main.dart`, `AppInitializer`, Splash |
| [[Flutter/Routing\|Routing]] | `AppNavRoutes`, `RouteGenerator`, `AppNavigation` |
| [[Flutter/Networking\|Networking]] | `ApiBaseHelper`, headers, POST-heavy API |
| [[Flutter/Storage and Caching\|Storage and Caching]] | SharedPreferences, cache, secure storage, PDF cache, images |
| [[Flutter/Theme\|Theme]] | `AppThemes.lightTheme`, `AppColors`, fonts |
| [[Flutter/Widgets\|Widgets]] | `lib/custom_widgets/` design-system folders |
| [[Flutter/Error Handling\|Error Handling]] | `AppExceptions` HTTP mapping |
| [[Flutter/Analytics and Logging\|Analytics and Logging]] | `AppAnalyticsService`, Crashlytics, `dart:developer` |

## Related

- [[Backend/Index|Backend]] — external AIMS+ API (not in this repo)
- [[Firebase/Index|Firebase]] — Messaging, Crashlytics, Analytics, Firestore, Remote Config
- [[Architecture/Index|Architecture]] — Provider MVVM overview

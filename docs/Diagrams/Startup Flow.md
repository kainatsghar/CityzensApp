---
title: Startup Flow
description: main to splash to optional promotion to AuthWrapper session guard.
tags: [cityzens, diagrams, startup, splash]
created: 2026-08-04
updated: 2026-08-04
owner: Cityzens Engineering
status: verified
---

# Startup Flow

> Back to [[Home]] · [[Diagrams/Index|Diagrams]] · [[Architecture/Navigation|Navigation]]

Cold start path from `main()` through splash, optional launch promotion, then auth.

## Mermaid

```mermaid
flowchart TD
  Main["main()<br/>WidgetsFlutterBinding"]
  Web{"kIsWeb?"}
  FCM["FirebaseMessaging.onBackgroundMessage"]
  Core["AppInitializer.ensureCoreInitialized"]
  Run["runApp TCSApp"]
  Boot["unawaited AppInitializer.bootstrapAll"]
  MP["MultiProvider · appProviders"]
  Mat["MaterialApp<br/>theme · navigatorKey · RouteGenerator"]
  Splash["SplashScreenUI · SplashProvider.loadInitialData"]
  Delay["~3s delay"]
  PromoCheck{"Active launch promotion?<br/>PromotionRepository"}
  PromoUI["PromotionScreenUI"]
  Auth["AuthWrapper /authWrapper"]
  Token{"tokenId?"}
  Login["LoginScreen"]
  Role{"userType"}
  Stud["StudentDashboardScreen"]
  Teach["TeacherDashboardScreen"]

  Main --> Web
  Web -->|Yes| Run
  Web -->|No| FCM --> Core --> Run
  Run --> Boot
  Run --> MP --> Mat --> Splash --> Delay --> PromoCheck
  PromoCheck -->|Yes live/test window| PromoUI --> Auth
  PromoCheck -->|No| Auth
  Auth --> Token
  Token -->|null| Login --> Auth
  Token -->|set| Role
  Role -->|Student| Stud
  Role -->|Teacher| Teach
  Role -->|Parent| Stud
```

## Promotion decision (`SplashProvider`)

After `PromotionRepository().getActivePromotion()`:

- **Release:** `isLive` and `startDate`/`endDate` contain `now`
- **Debug:** `isTesting`
- Web skips promotion fetch → AuthWrapper after delay

Evidence: `lib/provider/Splash/splash_provider.dart`.

## Bootstrap vs first frame

| Step | Blocking? |
|---|---|
| `ensureCoreInitialized` (native) | Yes — before `runApp` |
| `bootstrapAll` (Crashlytics, Analytics, FCM listeners, Push init) | No — `unawaited` |
| Splash 3s + promotion fetch | Parallel with bootstrap |

## Key files

| File | Role |
|---|---|
| `lib/main.dart` | Entry |
| `lib/services/InitServices/app_initializer.dart` | Firebase core + bootstrap |
| `lib/screens/SplashScreen/splash_screen_ui.dart` | Splash UI |
| `lib/provider/Splash/splash_provider.dart` | Promotion gate |
| `lib/screens/AuthWrapper/auth_wrapper.dart` | Session guard |
| `lib/repositories/Promotion/promotion_repository.dart` | Launch promotions API |

## Related pages

- [[Architecture/Navigation|Navigation]] · [[Architecture/Dependency Injection|DI]]
- [[Diagrams/Notification Flow|Notification Flow]] · [[Diagrams/Configuration Flow|Configuration Flow]]
- [[Flows/Authentication Flow|Authentication Flow]]

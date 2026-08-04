---
title: Flutter Routing
description: Named routes via AppNavRoutes, RouteGenerator, and AppNavigation — no deep-link package.
tags: [cityzens, flutter, routing, navigation]
created: 2026-08-04
updated: 2026-08-04
owner: Cityzens Engineering
status: verified
---

# Routing

> Back to [[Home]] · [[Flutter/Index|Flutter]] · [[Diagrams/Master Architecture|Master Architecture]]

Sources: `lib/routes/app_navigation_routes.dart`, `lib/routes/route_generator.dart`, `lib/routes/app_navigation.dart`, `lib/main.dart`.

## Stack

| Piece | Role |
|---|---|
| `AppNavRoutes` | String route name constants + `isRouteAvailable` |
| `RouteGenerator.generateRoute` | `onGenerateRoute` switch → screen widgets |
| `AppNavigation` | Global `navigatorKey` helpers (`navigateTo`, `pushReplacementTo`, `pushAndKillAll`, `goBack`, …) |
| Argument types | `ScreenArguments`, `ChallanArgs`, plus typed casts in generator (e.g. diary/assignment/circular models) |

Transitions use `PageRouteBuilder` with a 300ms `FadeTransition`. Unknown routes → `_errorRoute()` (`CustomAppBar` + `ShowError`).

## No deep links

Verified from the codebase:

- No `uni_links`, `app_links`, `go_router`, or `FirebaseDynamicLinks` usage.
- Navigation is in-app named routes and FCM payload routing (see [[Firebase/Messaging|Messaging]]).

> [!warning] Verification Required
> Whether OS-level URL schemes / App Links / Universal Links are configured only in native project files (outside Dart) was not audited for this page.

## Notable route constants

| Constant | Path |
|---|---|
| `initialRoute` | `/` → `SplashScreenUI` |
| `loginRoute` | `/login` |
| `authWrapperRoute` | `/authWrapper` |
| `studentDashboardRoute` / `parentDashboardRoute` | both `/studentDashboard` |
| `teacherDashboardRoute` | `/teacherDashboard` |
| `markAttendanceRoute` | `/markAttendance` |
| `studentDiaryRoute` / `teacherDiaryRoute` / `addDiaryRoute` | diary screens |
| `feeChallansRoute` / `challanPaymentRoute` | fees / WebView payment |
| `promotionRoute` / `promotionManagementRoute` | launch promotions |

`AppNavRoutes.isRouteAvailable` checks a `Set` of known constants (used by push tap routing). Note: `promotionManagementRoute` is defined and handled in `RouteGenerator` but is **not** included in the `isRouteAvailable` set.

## `AppNavigation` API

- `navigateTo` → `pushNamed`
- `pushReplacementTo` → `pushReplacementNamed`
- `pushAndKillAll` → `pushNamedAndRemoveUntil` until `initialRoute`
- `removeRoutesUntil` / `removeAllRoutes` / `goBack` / `canPop`
- Default arguments: `const ScreenArguments()` when omitted
- `currentContext` from `navigatorKey.currentState?.overlay?.context`

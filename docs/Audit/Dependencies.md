---
title: Dependencies
description: Important pubspec packages, purpose, and unused-looking or overlapping dependencies.
tags: [cityzens, audit, dependencies, pubspec]
created: 2026-08-04
updated: 2026-08-04
owner: Cityzens Engineering
status: verified
---

# Dependencies

> Back to [[Audit/Index|Audit]] · Source: `pubspec.yaml` (`tcs_app` **2.0.0+89**, SDK `^3.8.1`)

## Important runtime packages

| Package | Constraint (pubspec) | Purpose in Cityzens |
|---|---|---|
| `provider` | ^6.1.5+1 | App-wide `ChangeNotifier` state — [[ADR-001 Provider MVVM]] |
| `http` | ^1.6.0 | REST via `ApiBaseHelper` |
| `flutter_secure_storage` | ^10.3.1 | Secure session / credential storage |
| `shared_preferences` | ^2.5.5 | Prefs + `LocalCacheManager` offline JSON |
| `local_auth` | ^3.0.2 | Biometric unlock |
| `firebase_core` | ^4.12.1 | Firebase bootstrap |
| `firebase_messaging` | ^16.4.3 | FCM push |
| `firebase_crashlytics` | ^5.2.6 | Crash reporting |
| `firebase_analytics` | ^12.4.5 | Analytics / `analyticsObserver` |
| `firebase_remote_config` | ^6.5.5 | Implemented but **init call commented out** |
| `cloud_firestore` | ^6.7.1 | Promotions / `newFeatures` feature flags |
| `flutter_local_notifications` | ^22.0.1 | Local notification display |
| `cached_network_image` | ^3.4.1 | Network image cache |
| `webview_flutter` | ^4.14.1 | Payment WebView (`challan_payment_screen.dart`) |
| `flutter_inappwebview` | ^6.1.5 | Result PDF viewer (`result_pdf_viewer_screen.dart`) |
| `url_launcher` | ^6.3.2 | External links |
| `image_picker` / `image_cropper` | ^1.2.3 / ^12.2.1 | Media capture / crop |
| `file_picker` | ^12.0.0-beta.7 | File selection (**beta** channel) |
| `open_filex` / `path_provider` | ^4.7.0 / ^2.1.5 | Open/download local files |
| `upgrader` | ^13.5.0 | Force/soft update gate on auth wrapper |
| `package_info_plus` / `device_info_plus` | ^10.2.0 / ^13.2.0 | Version / device metadata |
| `connectivity_plus` | ^7.2.0 | Intended for `ConnectivityProvider` |
| `table_calendar` / `fl_chart` / `percent_indicator` | various | Calendar, charts, progress UI |
| `lottie` / `animate_do` / `flutter_spinkit` | various | Motion / loading |
| `json_annotation` / `freezed_annotation` | ^4.12.0 / ^3.1.0 | Model codegen annotations |
| `intl` | ^0.20.3 | Formatting |
| `flutter_email_sender` | ^10.0.1 | Feedback / mail compose |
| `fluttertoast` / `flutter_linkify` / `flutter_masked_text2` | various | Toasts, linkify, masked inputs |
| `cupertino_icons` | ^1.0.9 | Cupertino icon font |

## Dev dependencies

| Package | Purpose |
|---|---|
| `flutter_test` | Widget tests (currently template-only) |
| `flutter_lints` | Analyzer lints |
| `build_runner` + `json_serializable` + `freezed` | Code generation |
| `flutter_gen` | Asset code gen → `lib/gen/` |
| `flutter_launcher_icons` | Launcher icon config (also listed under dependencies) |

## Unused-looking / dormant

| Package / item | Why it looks unused | Code evidence |
|---|---|---|
| `connectivity_plus` | Provider not registered | `ConnectivityProvider` exists; absent from `app_providers.dart` — [[Audit/Known Issues\|Known Issues]] |
| `firebase_remote_config` | Init disabled | `_initRemoteConfig()` commented in `FirebaseMaster.initialize` |
| `file_picker` | On **beta** (`^12.0.0-beta.7`) | Higher churn risk than stable pins; confirm still required at call sites before upgrade |
| `launch_review` | Commented out of pubspec | `# launch_review: ^3.0.1` — not a live dependency |

## Overlap note: two WebView packages

Both **`webview_flutter`** and **`flutter_inappwebview`** are dependencies and **both are used**:

| Package | Call site |
|---|---|
| `webview_flutter` | Parent challan payment screen |
| `flutter_inappwebview` | Result PDF viewer screen |

Prefer consolidating to one stack long-term to reduce native footprint and API surface — tracked as consistency debt in [[Audit/Code Quality|Code Quality]].

## Related

- [[Flutter/Networking|Networking]]
- [[Firebase/Index|Firebase]]
- [[ADR-001 Provider MVVM]]

---
title: Project Structure
description: Responsibilities of important folders in the Cityzens Flutter repo.
tags: [cityzens, overview, structure]
created: 2026-08-04
updated: 2026-08-04
owner: Cityzens Engineering
status: verified
---

# Project Structure

## Repository root

| Path | Responsibility |
|---|---|
| `lib/` | Application source |
| `android/` / `ios/` | Native hosts, Firebase configs, signing |
| `assets/` | Images, fonts, Lottie |
| `docs/` | Obsidian vault (this documentation) |
| `test/` | Minimal widget test |
| `makefile` | Common Flutter/iOS/build commands |
| `pubspec.yaml` | Package `tcs_app`, version `2.0.0+89` |
| `firebase.json` | FlutterFire mapping |
| `keyStore/` | Android keystore path reference (`.jks` gitignored) |

## `lib/` layout

| Path | Responsibility | Depends on |
|---|---|---|
| `main.dart` | Entry, FCM background handler, `MultiProvider`, `MaterialApp` | InitServices, routes, providers |
| `screens/` | Full-page UIs by role/feature | components, providers, routes |
| `components/` | Feature UI compositions | custom_widgets, providers |
| `custom_widgets/` | Design-system primitives | utils (colors/themes) |
| `provider/` | ChangeNotifier state (30 registered) | services, repositories, models |
| `services/` | Static API / platform services | network, models |
| `repositories/` | Offline-first / Firestore subset | services, LocalCache, Firestore |
| `model/` | DTOs (some Freezed) | json / freezed codegen |
| `network/` | `ApiBaseHelper`, exceptions | `http`, `AppConstants` |
| `routes/` | Named routes, navigator, args | screens |
| `utils/` | Colors, themes, constants, validators, helpers | — |
| `shared_preference/` | SharedPreferences wrapper | — |
| `services/InitServices/` | Firebase + push bootstrap | Firebase SDKs |
| `push_notifications/` | Legacy commented manager | — |
| `gen/` | Generated assets/fonts | flutter_gen |
| `firebase_options.dart` | Firebase options | Firebase |

## Related

- [[Overview/Index|Overview]] · [[Architecture/Index|Architecture]] · [[Home]]

---
title: Overview
description: Project purpose, platforms, and technology stack for Cityzens.
tags: [cityzens, overview]
created: 2026-08-04
updated: 2026-08-04
owner: Cityzens Engineering
status: verified
---

# Overview

Tri-role school management app for **The City School** network. Teachers create academic content; students and parents consume it in near real time via the AIMS+ ERP API.

## Purpose

- Unify teacher classroom workflows (attendance, diary, classwork, circulars, tests, timetable)
- Give students/parents visibility into attendance, homework, results, fees, library, and school events
- Integrate push notifications, Crashlytics, Analytics, and Firestore feature flags

## Supported platforms

| Platform | Status | Notes |
|---|---|---|
| Android | Primary | `com.tcs.tcsapp` |
| iOS | Primary | Bundle `com.tcs.tcsapp` |
| Web | Partial | `main.dart` skips FCM background path; Firebase options throw for unsupported platforms |
| macOS / Linux / Windows | Scaffold only | Not production targets |

## High-level architecture

See [[Home]] master diagram and [[Architecture/Index|Architecture]].

```
Screens → Components → Custom Widgets
        ↕
   Providers (ChangeNotifier)
        ↕
 Services (static) / Repositories (subset)
        ↕
   Models ←→ ApiBaseHelper (http)
        ↕
 SharedPreferences / LocalCache / SecureStorage
```

## Technology stack

| Area | Choice | Evidence |
|---|---|---|
| Framework | Flutter / Dart `^3.8.1` | `pubspec.yaml` |
| State | `provider` | `lib/provider/app_providers.dart` |
| HTTP | `http` | `lib/network/api_base_helper.dart` |
| Firebase | Core, Messaging, Crashlytics, Analytics, Firestore, Remote Config (init off) | `lib/services/InitServices/` |
| UI fonts | Axiforma, Nunito | `pubspec.yaml` fonts |
| Codegen | freezed, json_serializable, flutter_gen | `makefile` `generate` / `gen` |

## Related

- [[Architecture/Index|Architecture]] · [[Features/Index|Features]] · [[Development/Setup|Setup]]
- [[Overview/Project Structure|Project Structure]] · [[Overview/Platforms|Platforms]]

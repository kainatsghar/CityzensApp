---
title: Vendor Guide
description: End-to-end vendor guide from setup through deploy, Firebase files, and troubleshooting.
tags: [cityzens, handover, vendor, guide]
created: 2026-08-04
updated: 2026-08-04
owner: Cityzens Engineering
status: verified
---

# Vendor Guide

> Back to [[Home]] · [[Handover/Index|Handover]]

Practical path for a vendor taking over Cityzens (`tcs_app`, version **2.0.0+89**).

## 1. Setup

Follow [[Development/Setup|Setup]]:

```bash
git clone https://github.com/tcsho/CityzensApp.git
cd CityzensApp
make get
make generate
make pod-install   # iOS
flutter run
```

## 2. Run & environments

- Default API: **Test** (`https://testcityzenapi.csn.edu.pk`) — [[Development/Environments|Environments]]
- Live host: `https://cityzenapi.csn.edu.pk` (switch `AppConstants.baseUrl` manually)
- `CITYZENS_ENV` dart-define is **unused** in Dart
- Firebase Remote Config init is **disabled**

## 3. Build

| Platform | Command |
|---|---|
| Android APK | `make apk` |
| Android App Bundle | `make appbundle` |
| iOS | `flutter build ios --release` then Xcode Archive |

Full target list: [[Development/Makefile|Makefile]].

## 4. Deploy

- Android signing: `android/key.properties` → `keyStore/key.jks` — [[Deployment/Android|Android]]
- iOS: Automatic signing, team **VGTWPL7QUR** — [[Deployment/iOS|iOS]]
- Align versions — [[Deployment/Versioning|Versioning]]
- Ship checklist — [[Deployment/Release Checklist|Release Checklist]]

## 5. Firebase files

| File | Location |
|---|---|
| Android Google Services | `android/app/google-services.json` |
| iOS Google Services | `ios/Runner/GoogleService-Info.plist` |
| Flutter options | `lib/firebase_options.dart` |

Project: `thecityschoolapp`. Messaging details: [[Firebase/Messaging|Messaging]].

## 6. Architecture & journeys

- Layers / providers: [[Architecture/Index|Architecture]]
- Startup: [[Flows/Splash and Startup Flow|Splash and Startup]]
- Payments / complaints gaps: [[Features/Index|Features]]
- Diagrams: [[Diagrams/Index|Diagrams]]

## 7. Troubleshooting

Common pods / baseUrl / FCM / signing / codegen issues: [[Troubleshooting/Index|Troubleshooting]].

## 8. Security notes for vendors

- Do not commit or share `key.properties` passwords or `.jks` contents.
- Repo-root `AuthKey_*.p8` is a **credential exposure risk** — rotate if shared; exclude from distribution — [[Deployment/iOS|iOS]].
- Prefer secrets vault over copying credentials into chat or docs.

## Related

- [[Handover/Index|Handover Index]]
- [[Credentials/Index|Credentials]]
- [[Audit/Documentation Audit Report|Documentation Audit Report]]

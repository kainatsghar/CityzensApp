---
title: Development Setup
description: Clone Cityzens, make get/generate/pod-install, and flutter run.
tags: [cityzens, development, setup]
created: 2026-08-04
updated: 2026-08-04
owner: Cityzens Engineering
status: verified
---

# Setup

> Back to [[Home]] · [[Development/Index|Development]] · [[Handover/Vendor Guide|Vendor Guide]]

Verified against root `README.md` Getting Started and `makefile`.

## Clone

```bash
git clone https://github.com/tcsho/CityzensApp.git
cd CityzensApp
```

## Install & generate

```bash
make get          # flutter pub get
make generate     # dart run build_runner build --delete-conflicting-outputs
make pod-install  # cd ios/ && pod install   (iOS / first time / after dep changes)
```

Optional: `make getAndGenerate` runs get then generate.

## Run

```bash
flutter run
```

Pick a device/simulator with Flutter tooling as usual.

## Firebase config files (expected)

| Platform | Path |
|---|---|
| Android | `android/app/google-services.json` |
| iOS | `ios/Runner/GoogleService-Info.plist` |
| Dart | `lib/firebase_options.dart` |

Firebase project id: `thecityschoolapp`.

## Active API host

Default in `AppConstants`: **Test** (`apiTestBaseURL`). See [[Environments]].

## Related

- [[Makefile]]
- [[Deployment/Index|Deployment]]
- [[Troubleshooting/Index|Troubleshooting]]

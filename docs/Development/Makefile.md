---
title: Makefile Targets
description: Documented make targets from the Cityzens root makefile.
tags: [cityzens, development, makefile]
created: 2026-08-04
updated: 2026-08-04
owner: Cityzens Engineering
status: verified
---

# Makefile

> Back to [[Home]] · [[Development/Index|Development]] · [[Setup]]

Source of truth: repo root `makefile` (lowercase filename).

## Targets

| Target | Command / effect |
|---|---|
| `get` | `flutter pub get` |
| `clean` | `flutter clean && make get` |
| `generate` | `dart run build_runner build --delete-conflicting-outputs` |
| `watch` | `dart run build_runner watch --delete-conflicting-outputs` |
| `getAndGenerate` | `make get && make generate` |
| `pod-install` | `cd ios/ && pod install` |
| `pod-repo-update` | `cd ios/ && pod install --repo-update` |
| `reset-pod` | Remove `Podfile.lock`, then `pod install` |
| `pod-deintegrate-and-install` | `pod deintegrate && pod install` |
| `reset-pod-cache` | Remove Pods + lock, `pod cache clean --all`, `pod install --repo-update` |
| `fast-pod` | Remove Pods + lock, `pod install --verbose --no-repo-update` |
| `appbundle` | `flutter build appbundle` |
| `apk` | `flutter build apk --release` |
| `test-apk` | Release APK with `--dart-define=CITYZENS_ENV=true` (flag unused in Dart — see [[Environments]]) |
| `fix` | `dart fix --apply` + `dart format .` + `dart sort_imports_script.dart lib/` |
| `gen` | `fluttergen -c pubspec.yaml` |
| `git-config` | Print `git config user.name` and `user.email` |

## Platform notes (from makefile header)

- macOS: `make` available by default
- Linux: install `make` via package manager
- Windows: Chocolatey `make` (see comments in `makefile`)

## Related

- [[Setup]]
- [[Deployment/Android|Android]]
- [[Deployment/iOS|iOS]]

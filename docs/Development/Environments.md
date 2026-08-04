---
title: Environments
description: Test and Live API hosts only; CITYZENS_ENV unused; Remote Config init disabled.
tags: [cityzens, development, environments, config]
created: 2026-08-04
updated: 2026-08-04
owner: Cityzens Engineering
status: verified
---

# Environments

> Back to [[Home]] · [[Development/Index|Development]] · Diagram: [[Diagrams/Configuration Flow|Configuration Flow]]

Cityzens has **two** API hosts. There is no third env tier in code.

## Hosts (`AppConstants`)

| Constant | URL | Active? |
|---|---|---|
| `apiTestBaseURL` | `https://testcityzenapi.csn.edu.pk` | **Yes** — `baseUrl = apiTestBaseURL` |
| `apiLiveBaseURL` | `https://cityzenapi.csn.edu.pk` | No (commented assignment) |

Derived: `apiBaseURL = "$baseUrl/api/"`.

To use Live, change `lib/utils/app_constants.dart` so `baseUrl` points at `apiLiveBaseURL` (manual switch).

## `CITYZENS_ENV` — unused in Dart

| Location | Behavior |
|---|---|
| `makefile` `test-apk` | Passes `--dart-define=CITYZENS_ENV=true` |
| README | Documents the flag |
| `lib/**/*.dart` | **No** `String.fromEnvironment('CITYZENS_ENV')` (or equivalent) |

Building with `make test-apk` does **not** change `baseUrl`. Prefer editing `AppConstants` for env selection.

## Remote Config — disabled

`FirebaseMaster.initialize` has `_initRemoteConfig()` **commented out**. The method exists and would apply `apiBaseUrl`, but it does not run at bootstrap. See [[Firebase/Remote Config|Remote Config]].

## Related

- [[Flutter/Networking|Networking]]
- [[Diagrams/Configuration Flow|Configuration Flow]]
- [[Makefile]]

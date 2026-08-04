---
title: "ADR-003: Test Live URL Switch"
description: Hardcoded AppConstants Test/Live base URLs; no Flutter flavors or dart-define-driven host.
tags: [cityzens, decisions, adr, configuration, environments]
created: 2026-08-04
updated: 2026-08-04
owner: Cityzens Engineering
status: verified
---

# ADR-003 — Test / Live URL Switch

> Back to [[Decisions/Index|Decisions]] · [[Diagrams/Configuration Flow|Configuration Flow]]

## Status

**Accepted** — active host is **Test** via source constant.

## Context

Cityzens talks to external AIMS+ ERP hosts:

| Role | URL |
|---|---|
| Test | `https://testcityzenapi.csn.edu.pk` |
| Live | `https://cityzenapi.csn.edu.pk` |

There is no in-repo backend and no Flutter flavor / scheme matrix for Dev/QA/UAT.

## Decision

Keep base URL selection in `lib/utils/app_constants.dart`:

```dart
// static String baseUrl = apiLiveBaseURL;
static String baseUrl = apiTestBaseURL;
```

`apiBaseURL` is derived as `"$baseUrl/api/"`. Switching environments is a **source edit** (uncomment Live / comment Test), then rebuild.

Remote Config key `apiBaseUrl` was intended to override at runtime, but `_initRemoteConfig()` is **commented out** in `FirebaseMaster` — see [[Firebase/Remote Config]].

`CITYZENS_ENV` appears in `makefile` / README as `--dart-define=CITYZENS_ENV=true` but is **unused in Dart** (no `String.fromEnvironment`).

## Alternatives considered

| Option | Tradeoff |
|---|---|
| Flutter flavors + `--dart-define=API_BASE_URL` | Proper CI/CD env matrix; more native project wiring |
| Always Remote Config | Dynamic without rebuild; depends on RC init (currently off) |
| Compile-time `CITYZENS_ENV` switch | Documented but never implemented in `lib/` |

## Consequences / current impact

**Positive**

- Extremely simple; one file owns the host
- Hard to accidentally ship Live from a misconfigured flavor file that does not exist

**Negative / observed**

- Easy to ship Test API against a store build if constants are not flipped
- Docs/tooling mentioning `CITYZENS_ENV` mislead newcomers
- iOS `pbxproj` marketing version already drifts from pubspec — env + version hygiene both manual
- No UAT/staging third host without more constants

## Related

- [[Audit/Known Issues|Known Issues]]
- [[Overview/Platforms|Platforms]]

---
title: "ADR-001: Provider MVVM"
description: Why Cityzens uses Provider + ChangeNotifier; alternatives Riverpod/Bloc; tradeoffs and current impact.
tags: [cityzens, decisions, adr, provider]
created: 2026-08-04
updated: 2026-08-04
owner: Cityzens Engineering
status: verified
---

# ADR-001 — Provider MVVM

> Back to [[Decisions/Index|Decisions]] · [[Architecture/State Management|State Management]]

## Status

**Accepted** — current code uses `provider` exclusively (`pubspec.yaml`; no Bloc / Riverpod / GetX).

## Context

Cityzens is a multi-role school ERP client (student / parent / teacher) with ~30 feature state objects, Firebase bootstrap, and a large screen tree. The team needed a Flutter-native state approach that screens could consume with `Consumer` / `Provider.of` without a heavy framework.

## Decision

Use **Provider + `ChangeNotifier`** as the Logic layer in a pragmatic MVVM shape:

- **View:** `lib/screens/`, `lib/components/`, `lib/custom_widgets/`
- **ViewModel:** `ChangeNotifier` classes under `lib/provider/`
- **Model / data:** `lib/model/`, static `lib/services/`, selective `lib/repositories/`

Registration: `MultiProvider(providers: appProviders)` in `lib/main.dart` → **30** factories in `lib/provider/app_providers.dart`.

## Alternatives considered

| Option | Why not (for this codebase) |
|---|---|
| **Riverpod** | Stronger compile-time safety and testability; would require rewriting all providers and widget watch sites |
| **Bloc / Cubit** | Explicit events/states scale well for complex flows; steeper boilerplate vs existing ChangeNotifier habits |
| **GetX** | Faster to prototype; weaker alignment with Flutter team guidance and harder long-term handover discipline |

## Consequences / current impact

**Positive**

- One consistent pattern across features; easy for Flutter-familiar vendors
- Documented provider map — [[Architecture/Provider Map|Provider Map]]

**Negative / observed**

- All notifiers created at app root (no feature-scoped providers)
- Many providers pull `LocalDataProvider` via `AppNavigation.currentContext!` in constructors — tight coupling
- `ConnectivityProvider` written but never registered — dead path despite package dep
- Harder unit testing without widget/context scaffolding — reflected in [[Audit/Code Quality|Code Quality]] testing score

## Related

- [[ADR-002 Static Services vs Repositories]]
- [[Audit/Known Issues|Known Issues]]

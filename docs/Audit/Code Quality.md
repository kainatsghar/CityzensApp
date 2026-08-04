---
title: Code Quality
description: Honest, evidence-based scores for architecture, SOLID, testing, and Flutter practices in Cityzens.
tags: [cityzens, audit, code-quality]
created: 2026-08-04
updated: 2026-08-04
owner: Cityzens Engineering
status: verified
---

# Code Quality

> Back to [[Audit/Index|Audit]] · Debt inventory: [[Audit/Known Issues|Known Issues]]

Scores are **out of 10**, calibrated against the current Flutter client (`tcs_app` **2.0.0+89**, ~400 Dart files under `lib/`). They are intentionally not inflated.

## Scorecard

| Dimension | Score | Notes |
|---|---:|---|
| Architecture | **6** | Clear Presentation → Provider → Service/Repo → Network story ([[Architecture/Layers\|Layers]]), but incomplete Clean Architecture and no DI container |
| Naming | **6.5** | Feature folders and `*_provider` / `*_service` suffixes are mostly consistent; package name `tcs_app` vs product “Cityzens”; some leftover `test_*.dart` screen experiments |
| Folder structure | **7** | Role/feature trees under `screens/`, `provider/`, `services/` work; empty `IEP` / `CircularAnnouncement` provider dirs and `Introduction.rar` hurt clarity |
| Reusability | **6** | Shared `custom_widgets/` and components help; A-Level `19`/`20` checks and similar branching are duplicated across screens/providers |
| Scalability | **5** | All **30** `ChangeNotifier`s registered at root; static services resist mocking; no flavors — Test/Live via hardcoded `AppConstants` |
| Maintainability | **5.5** | Readable feature slices, but mocked Complaint save, unused helpers, `AppNavigation.currentContext!` coupling, and hybrid Service vs Repository patterns raise change cost |
| Performance | **6.5** | Offline-first repos + `LocalCacheManager` for some dashboards; full provider tree always mounted; image/PDF paths use caching packages where present |
| Testing | **2** | Only default `test/widget_test.dart` counter smoke test — no unit/widget coverage of providers, services, or flows |
| Documentation coverage | **7** | Vault (Flows, Architecture, Firebase, Audit) is strong after the 2026 refresh; README still partially overlaps; ADRs newly formalized |
| Consistency | **5.5** | Dual WebView stacks (`webview_flutter` + `flutter_inappwebview`); five repos vs dozens of static services; some providers resolve peers via global context |
| SOLID | **4.5** | Providers often mix UI orchestration, validation, and API calls (SRP); DIP weak — concrete static services everywhere; OCP strained by hardcoded grade/feature flags |
| Clean Architecture adherence | **4** | Informal layers exist; no domain layer / use cases; repositories are partial and inconsistently used ([[ADR-002 Static Services vs Repositories]]) |
| Flutter best practices | **5.5** | Provider usage is idiomatic at registration; widespread `currentContext!`, commented production paths, and unused Bearer headers are anti-patterns |

**Overall (unweighted mean):** ~**5.5 / 10** — shippable production client with coherent feature structure, held back by test debt, incomplete abstraction boundaries, and known dead/mock paths.

## Strengths

- Single state approach: Provider + `ChangeNotifier` only ([[ADR-001 Provider MVVM]])
- Feature-oriented folders map cleanly to student / teacher / parent journeys
- Selective offline cache via repositories for dashboard-ish data
- Firebase bootstrap centralized (`FirebaseMaster`, `AppInitializer`, `PushNotifications`)

## Weaknesses (evidence-backed)

1. **Auth header bug / dead construction** in `ApiBaseHelper.httpPostRequest` — [[Audit/Known Issues|Known Issues]]
2. **Feature flag repository unused** on payment navigation (`isNewPaymentFlowEnabled: true`) — [[ADR-004 Firestore Feature Flags]]
3. **No automated tests** beyond template widget test
4. **Env story fragmented**: `CITYZENS_ENV` unused; Remote Config init off; URL flip is a source comment change — [[ADR-003 Test Live URL Switch]]
5. **Security hygiene**: AuthKey `.p8` at repo root tracked; duplicate plist

## Suggested priorities (not a roadmap commitment)

1. Wire or delete `ConnectivityProvider` / unused HTTP verbs / legacy push manager
2. Restore Complaint Query API path or remove success UX
3. Consume `FeatureConfigRepository` on Pay navigation
4. Add unit tests for `ApiBaseHelper` header behavior and critical providers
5. Align iOS `MARKETING_VERSION` / build with `pubspec` `2.0.0+89`
6. Remove secrets from VCS; keep only references in gitignored `secrets.md`

## Related

- [[Audit/Dependencies|Dependencies]]
- [[Architecture/Index|Architecture]]
- [[Decisions/Index|ADRs]]

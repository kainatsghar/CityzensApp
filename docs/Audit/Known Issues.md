---
title: Known Issues
description: Code-verified tech debt, dead code, security hygiene, and configuration gaps in Cityzens.
tags: [cityzens, audit, tech-debt, known-issues]
created: 2026-08-04
updated: 2026-08-04
owner: Cityzens Engineering
status: verified
---

# Known Issues

> Back to [[Audit/Index|Audit]] · Personal notes mirror: [[Notes/Index|Notes]] (this page is canonical)

> [!info] Verification
> Findings below were checked against `lib/`, `pubspec.yaml`, `ios/Runner.xcodeproj/project.pbxproj`, and repo root on **2026-08-04**. Do not paste secret file contents into the vault.

## Connectivity / providers

| Issue | Evidence | Impact |
|---|---|---|
| `ConnectivityProvider` exists but is **not** registered | `lib/provider/Connectivity/connectivity_provider.dart` present; **no** match in `lib/provider/app_providers.dart` (30 providers only) | `connectivity_plus` dependency has no live UI consumer via Provider |
| Empty provider directories | `lib/provider/IEP/` and `lib/provider/CircularAnnouncement/` are empty (no Dart files) | Scaffold leftovers; confuse onboarding |

## Environment / Firebase

| Issue | Evidence | Impact |
|---|---|---|
| `CITYZENS_ENV` unused in Dart | `makefile` / `README.md` pass `--dart-define=CITYZENS_ENV=true`; **no** `String.fromEnvironment('CITYZENS_ENV')` under `lib/` | Documented env switch is a no-op at runtime |
| Remote Config init commented out | `FirebaseMaster.initialize()` lists `// _initRemoteConfig(),` in `lib/services/InitServices/firebase_master.dart` | `firebase_remote_config` package installed; RC path dormant — see [[Firebase/Remote Config]] |

## Networking

| Issue | Evidence | Impact |
|---|---|---|
| `ApiBaseHelper` builds Bearer headers but POSTs `appHeaders` only | `httpPostRequest` builds `headers` with `Authorization: Bearer $token` + `appHeaders`, then calls `http.post(..., headers: AppConstants.appHeaders)` — `lib/network/api_base_helper.dart` | Auth header construction is dead; token param unused on the wire |
| GET / PUT / PATCH / DELETE helpers unused | Defined in `api_base_helper.dart`; call sites outside that file: **none** (ERP traffic uses POST / multipart POST) | Dead API surface |

## Feature gaps / mocks

| Issue | Evidence | Impact |
|---|---|---|
| Complaint Query **save** mocked | `ComplaintQueryProvider.saveComplaintQueryRequest` shows success after `Future.delayed`; real `AddWithdrawalRequestService` call is **commented out** | Users see success without API write — [[Flows/Complaint and Query Flow]] |
| `FeatureConfigRepository` unused on Pay path | Repository only referenced in its own file; `outstanding_fee_component.dart` passes `isNewPaymentFlowEnabled: true` hardcoded | Firestore `newFeatures/newPaymentFlow` flag never gates payment UI — [[ADR-004 Firestore Feature Flags]] |

## Security hygiene

| Issue | Evidence | Impact |
|---|---|---|
| Apple AuthKey `.p8` at repo root | File `AuthKey_J49ACV752S.p8` tracked at repository root; **not** listed in `.gitignore` | Private key material in VCS — rotate if ever exposed; store path/ID only in gitignored [[Credentials/Index\|secrets.md]]; **do not paste contents** |
| Duplicate `GoogleService-Info.plist` | Root copy **and** `ios/Runner/GoogleService-Info.plist` | Drift risk; Runner copy is the iOS build input |

## Testing / routing / versioning

| Issue | Evidence | Impact |
|---|---|---|
| Minimal tests only | `test/widget_test.dart` is the default Flutter counter smoke test (`MaterialApp()` + increment icons) — not app-specific | No regression net for providers/services |
| Parent dashboard route == student | `AppNavRoutes.parentDashboardRoute` and `studentDashboardRoute` both `'/studentDashboard'` in `lib/routes/app_navigation_routes.dart` | Parent vs student route identity collapsed |
| iOS pbxproj version stale | Runner `MARKETING_VERSION = 1.13.1`, `CURRENT_PROJECT_VERSION = 87` vs `pubspec.yaml` `2.0.0+89` | Store/build metadata can disagree with Flutter version |

## A-Level grade IDs (hardcoded 19 / 20)

**Still true** (verified in code):

- `student_profile_card.dart`: `['19', '20'].contains(gradeId)`
- `teacher_dashboard_screen.dart`, `mark_attendance_provider.dart`, `teacher_section_component.dart`, `student_list_component.dart`: `classId == 19 \|\| classId == 20`

Not configurable via Remote Config / Firestore / constants class. Changing grade IDs in ERP requires multi-file edits.

## Dead / odd artifacts

| Issue | Evidence | Impact |
|---|---|---|
| Legacy push manager fully commented | Entire body of `lib/push_notifications/push_notifications_manager.dart` is commented; live path is `PushNotifications` under InitServices | Dead file noise |
| `Introduction.rar` under screens | `lib/screens/Introduction.rar` | Non-source archive in `lib/` — remove or relocate outside app sources |

## Related

- [[Audit/Code Quality|Code Quality]]
- [[Audit/Dependencies|Dependencies]]
- [[Decisions/Index|ADRs]]
- [[Backend/API Client|API Client]]

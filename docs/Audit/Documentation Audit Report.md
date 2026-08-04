---
title: Documentation Audit Report
description: Baseline audit of Obsidian vault vs Flutter codebase before the 2026 handover documentation refresh.
tags: [cityzens, audit, documentation]
created: 2026-08-04
updated: 2026-08-04
owner: Cityzens Engineering
status: verified
---

# Documentation Audit Report

> [!abstract] Verdict
> The vault had strong **Flows** and a solid **Provider Map**, but was incomplete for vendor handover: stub API docs, no Firebase/Deployment/Handover folders, stale version `1.13.3+88` (code is **`2.0.0+89`**), and no master SSOT diagram.

## Scope

| Item | Value |
|---|---|
| Package | `tcs_app` |
| App version (pubspec) | `2.0.0+89` |
| Repo type | Flutter client only — **no .NET sources in-repo** |
| Backend | External AIMS+ ERP REST (`testcityzenapi` / `cityzenapi`.csn.edu.pk) |
| Audit date | 2026-08-04 |

## Existing documentation (pre-refresh)

| Path | Maturity | Notes |
|---|---|---|
| [[Home]] | Hub only | Version stale; no master diagram |
| [[Architecture/Index\|Architecture]] | Strong | Omits repositories, InitServices, biometrics |
| [[Architecture/Provider Map\|Provider Map]] | Strong | 30 providers — matches `app_providers.dart` |
| [[Flows/Index\|Flows]] (14 flows) | Strongest | Auth/Student/Homework deepest |
| [[API/Index\|API]] | Weak | ~4 endpoints; code has 60+ |
| [[Design System/Index\|Design System]] | Good | Color tokens partially stale vs `AppColors` |
| [[Features/Index\|Features]] | Good | Overlaps README matrix |
| [[Notes/Index\|Notes]] | Stub | 5 tech-debt bullets |
| [[Credentials/Index\|Credentials]] | Stub | Points to gitignored `secrets.md` (absent) |
| Root `README.md` | Comprehensive | Duplicates vault; version stale |
| Root `CHANGELOG.md` | Stub | Only `[0.1.0]` |

**Obsidian features pre-refresh:** Wikilinks + Mermaid heavy in Flows. No YAML frontmatter, almost no tags/callouts, no ADRs.

## Missing documentation (pre-refresh)

- Overview, Flutter, Backend, Firebase, Development, Deployment, Handover, Decisions, Diagrams, Troubleshooting, Audit folders
- Master architecture SSOT diagram
- Full API endpoint catalog
- Screen → Service/Repo → API → Model → UI maps
- Splash / Promotion / Notification / Result PDF flows
- Package dependency rationale
- Formal Known Issues / Code Quality / ADRs
- Vendor handover guide

## Outdated / incorrect (code-verified)

1. Version `1.13.3+88` in Home/README vs `2.0.0+89` in `pubspec.yaml`
2. Broken wikilink `[[API/Endpoint Reference]]` → real page is [[API/Index]]
3. Architecture omitted `lib/repositories/`, InitServices, biometrics, Promotion, FeatureConfig
4. Remote Config documented as active; `_initRemoteConfig()` call is **commented out**
5. Design System color names/hex mismatched vs `lib/utils/app_colors.dart`
6. `CITYZENS_ENV` dart-define documented but **unused in Dart**
7. No Dev/QA/UAT flavors exist — only Test vs Live URL constants
8. iOS `project.pbxproj` still shows marketing version `1.13.1` / build `87`

## Proposed changes (executed in this refresh)

| Action | Detail |
|---|---|
| Create | Master flowchart + mind maps on [[Home]]; [[Diagrams/Index\|Diagrams]] mirrors |
| Create | Full folder tree per handover plan with Index pages + frontmatter |
| Expand | [[API/Index\|API]] catalog from all `lib/services/**` + repositories |
| Expand | [[Firebase/Index\|Firebase]], [[Flutter/Index\|Flutter]], [[Backend/Index\|Backend]] |
| Refresh | Flows, Features, Architecture, Design System against code |
| Add | [[Audit/Known Issues\|Known Issues]], [[Audit/Code Quality\|Code Quality]], [[Audit/Dependencies\|Dependencies]], ADRs |
| Add | [[Handover/Index\|Handover]], [[Development/Index\|Development]], [[Deployment/Index\|Deployment]] |
| Sync | README thin pointer; CHANGELOG seed for `2.0.0+89` |

## New files created (target set)

See vault tree on [[Home]]. Key new roots: `Overview/`, `Flutter/`, `Backend/`, `Firebase/`, `Diagrams/`, `Development/`, `Deployment/`, `Handover/`, `Decisions/`, `Troubleshooting/`, `Audit/`.

## Validation rules

- Every factual claim cites a path under `lib/`, `android/`, `ios/`, or `pubspec.yaml`
- Unverifiable items use `> [!warning] Verification Required`
- Never paste secret values into the vault

## Related

- [[Home]]
- [[Audit/Index|Audit Index]]
- [[Handover/Index|Handover]]

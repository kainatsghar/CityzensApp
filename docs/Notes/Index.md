---
title: Notes
description: Personal notes and tech-debt pointers; canonical debt list lives under Audit.
tags: [cityzens, notes, tech-debt]
created: 2026-08-04
updated: 2026-08-04
owner: Cityzens Engineering
status: verified
---

# Personal Notes

This section is for personal notes, observations, and reminders.

> [!important] Canonical tech debt
> Treat [[Audit/Known Issues|Audit → Known Issues]] as the **source of truth** for verified debt. Keep the bullets below as a short personal checklist only.

## Quick Notes

- 

## Meeting Notes

- 

## Ideas & Improvements

- 

## Technical Debt / Known Issues

Canonical detail: [[Audit/Known Issues]]

- `ApiBaseHelper.httpPostRequest()` builds auth headers but doesn't actually send them (uses `AppConstants.appHeaders` instead)
- Some providers access `AppNavigation.currentContext!` in constructor body — tight coupling
- `LoginResponse.toJson()` doesn't include all fields (e.g., `isSuccessful`, `message`)
- A-Level grade detection uses hardcoded `['19', '20']` — should be configurable
- `parentDashboardRoute` and `studentDashboardRoute` point to the same route string `/studentDashboard`

## Related

- [[Audit/Code Quality|Code Quality]]
- [[Audit/Dependencies|Dependencies]]
- [[Decisions/Index|ADRs]]

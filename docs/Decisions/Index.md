---
title: Decisions
description: Architecture Decision Records for Cityzens Flutter client.
tags: [cityzens, decisions, adr]
created: 2026-08-04
updated: 2026-08-04
owner: Cityzens Engineering
status: verified
---

# Architecture Decision Records

> Back to [[Home]] · Related: [[Architecture/Index|Architecture]] · [[Audit/Index|Audit]]

ADRs capture **why** the app is structured as it is. Status `verified` means the decision still matches current code (2026-08-04).

## Index

| ADR | Title | Status |
|---|---|---|
| [[ADR-001 Provider MVVM]] | Provider + ChangeNotifier as state layer | Accepted / current |
| [[ADR-002 Static Services vs Repositories]] | Hybrid static services + selective repositories | Accepted / current |
| [[ADR-003 Test Live URL Switch]] | Hardcoded `AppConstants` Test/Live URLs (no flavors) | Accepted / current |
| [[ADR-004 Firestore Feature Flags]] | Firestore `newFeatures` collection for flags | Accepted / gap on Pay path |

## Related audits

- [[Audit/Known Issues|Known Issues]]
- [[Audit/Code Quality|Code Quality]]
- [[Audit/Dependencies|Dependencies]]

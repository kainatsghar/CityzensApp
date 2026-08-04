---
title: "ADR-002: Static Services vs Repositories"
description: Hybrid data access — static ERP services plus five selective repositories.
tags: [cityzens, decisions, adr, repositories, services]
created: 2026-08-04
updated: 2026-08-04
owner: Cityzens Engineering
status: verified
---

# ADR-002 — Static Services vs Repositories

> Back to [[Decisions/Index|Decisions]] · [[Architecture/Repositories|Repositories]] · [[Architecture/Dependency Injection|DI]]

## Status

**Accepted** — hybrid pattern is live in code.

## Context

Most ERP endpoints are thin POST wrappers. A minority of features need offline-first caching or Firestore-backed config. Introducing a full repository layer for every endpoint would be high churn for little gain.

## Decision

1. **Default:** static service classes under `lib/services/**` calling `ApiBaseHelper` (no constructor injection, no interface).
2. **Selective repositories** under `lib/repositories/` when caching, aggregation, or Firestore is required:
   - `PromotionRepository`
   - `FeatureConfigRepository`
   - `StudentDashboardRepository`
   - `TeacherSectionRepository`
   - `SectionSubjectRepository`
3. **No GetIt / injectable** — providers construct repos ad hoc (`PromotionRepository()`, etc.) or call static services directly.

## Alternatives considered

| Option | Tradeoff |
|---|---|
| Repository-everywhere | Cleaner DIP / test seams; large rewrite of 50+ service folders |
| Service-only | Simpler mental model; loses offline-first and Firestore abstraction already started |
| Full DI container | Better test doubles; new toolchain and registration ceremony |

## Consequences / current impact

**Positive**

- Fast feature delivery for CRUD-like ERP calls
- Offline cache concentrated where it matters (`LocalCacheManager`)

**Negative / observed**

- Inconsistent abstraction: callers must know whether a feature uses Service or Repository
- Static services resist mocking → testing score remains low
- `FeatureConfigRepository` exists but Pay path ignores it (hardcoded `true`) — [[ADR-004 Firestore Feature Flags]]
- Clean Architecture adherence stays partial — [[Audit/Code Quality|Code Quality]]

## Related

- [[Backend/API Client|API Client]]
- [[Architecture/Layers|Layers]]

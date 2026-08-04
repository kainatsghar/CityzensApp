---
title: "ADR-004: Firestore Feature Flags"
description: newFeatures collection for flags; Pay path currently hardcodes enabled=true.
tags: [cityzens, decisions, adr, firestore, feature-flags]
created: 2026-08-04
updated: 2026-08-04
owner: Cityzens Engineering
status: verified
---

# ADR-004 — Firestore Feature Flags

> Back to [[Decisions/Index|Decisions]] · [[Firebase/Firestore|Firestore]] · [[Architecture/Repositories|Repositories]]

## Status

**Accepted** for storage design · **Implementation gap** on payment navigation (verified 2026-08-04).

## Context

Some client behaviors (notably the “new payment flow”) need remote toggling without waiting for store review. Firebase Remote Config init is currently off ([[ADR-003 Test Live URL Switch]]); Firestore is already used for promotions.

## Decision

Use Firestore collection **`newFeatures`** with documents such as **`newPaymentFlow`**, accessed via `FeatureConfigRepository`:

- `getNewPaymentFlow()`
- `getNewFeaturesList()`
- `streamNewPaymentFeature()`
- `addNewFeature(...)`

Model: `FeatureConfigModel` under `lib/model/Firebase/FeatureConfig/`.

Payment UI is supposed to receive `ChallanArgs.isNewPaymentFlowEnabled` and branch in `challan_payment_screen.dart`.

## Current impact (gap)

At verification time:

- **No call sites** outside `feature_config_repository.dart` construct or invoke `FeatureConfigRepository`
- Pay Now navigation in `outstanding_fee_component.dart` passes:

```dart
isNewPaymentFlowEnabled: true,
```

So the Firestore flag **does not gate** the live Pay path. The repository remains the intended SSOT but is unused by UI.

## Alternatives considered

| Option | Tradeoff |
|---|---|
| Firebase Remote Config boolean | Fits flags well; RC bootstrap currently disabled |
| Hardcode only | What Pay path does today — no remote kill switch |
| ERP-driven config endpoint | Keeps flags with AIMS+; not implemented |

## Consequences

**Positive (design)**

- Flags can be changed in Firebase console without app release
- Stream API ready for live updates

**Negative (as shipped)**

- Dead abstraction until wired; operators may believe toggling `newPaymentFlow` changes the app when it does not
- Tracked under [[Audit/Known Issues|Known Issues]] and [[Diagrams/Payment Flow|Payment Flow]]

## Recommended fix (not executed here)

Resolve flag via `FeatureConfigRepository.getNewPaymentFlow()` (or stream) before `AppNavigation.navigateTo(challanPaymentRoute, …)` and pass the real boolean into `ChallanArgs`.

## Related

- [[ADR-002 Static Services vs Repositories]]
- [[Audit/Code Quality|Code Quality]]

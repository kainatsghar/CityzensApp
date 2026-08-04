---
title: Firebase Firestore
description: FeatureConfigRepository for newFeatures collection and newPaymentFlow document.
tags: [cityzens, firebase, firestore, feature-flags]
created: 2026-08-04
updated: 2026-08-04
owner: Cityzens Engineering
status: verified
---

# Firestore

> Back to [[Home]] · [[Firebase/Index|Firebase]] · [[Backend/Screen API Maps|Screen API Maps]] · [[Diagrams/Master Architecture|Master Architecture]]

Sources: `lib/repositories/FeatureConfig/feature_config_repository.dart`, `lib/model/Firebase/FeatureConfig/feature_config_model.dart`.

Firestore is used for client-side config/content (not the AIMS+ ERP). Feature flags live in collection **`newFeatures`**.

## `FeatureConfigRepository`

| Method | Path | Behavior |
|---|---|---|
| `getNewPaymentFlow` | `newFeatures` / doc `newPaymentFlow` | One-shot get → `FeatureConfigModel?` |
| `getNewFeaturesList` | `newFeatures` collection | All docs → `List<FeatureConfigModel>?` |
| `streamNewPaymentFeature` | `newFeatures/newPaymentFlow` | Snapshot stream |
| `addNewFeature` | `newFeatures/{newFeature.id}` | `set(toJson())` |

Model fields: `id`, `isLive`, `isTest`, `isTesting`, `startDate`, `endDate`.

`FeatureConfigModel.isActive`:

- **Debug:** returns `isTesting`
- **Release:** requires `isLive` and optional start/end window
- Otherwise `false`

## Payment flow wiring (verified gap)

`ChallanPaymentScreen` chooses gateway URL from `ChallanArgs.isNewPaymentFlowEnabled`.

`outstanding_fee_component.dart` navigates with **`isNewPaymentFlowEnabled: true`** (hardcoded).

> [!warning] Verification Required
> No Dart call site instantiates or awaits `FeatureConfigRepository` outside its own file. Whether product intent is to drive payment URLs from Firestore `newPaymentFlow` is not wired in the current UI path.

## Other Firestore usage

Promotion content also uses Firestore via `PromotionRepository` (splash / launch ads). That repository is separate from FeatureConfig.

## Package

`cloud_firestore` in `pubspec.yaml`.

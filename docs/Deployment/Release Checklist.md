---
title: Release Checklist
description: Pre-release verification checklist for Cityzens Android and iOS ships.
tags: [cityzens, deployment, release, checklist]
created: 2026-08-04
updated: 2026-08-04
owner: Cityzens Engineering
status: verified
---

# Release Checklist

> Back to [[Home]] · [[Deployment/Index|Deployment]]

Use before Play Store / App Store submission.

## Version & config

- [ ] `pubspec.yaml` version bumped intentionally (current SSOT: **2.0.0+89**)
- [ ] iOS `MARKETING_VERSION` / build number aligned (see [[Versioning]] — may still show `1.13.1` / `87`)
- [ ] `AppConstants.baseUrl` points at intended host (Test vs Live) — [[Environments]]
- [ ] Confirm Remote Config remains disabled unless intentionally re-enabled

## Build hygiene

- [ ] `make get` && `make generate`
- [ ] iOS: `make pod-install` (or reset pods if needed)
- [ ] Smoke-test login for Student / Teacher / Parent on target env
- [ ] Fee WebView opens expected billing URL
- [ ] FCM: permission + sample notification on release build

## Android

- [ ] `android/key.properties` present; points at `keyStore/key.jks` (secrets not logged)
- [ ] `make appbundle` (or APK if sideload)
- [ ] `google-services.json` present for release flavor/project

## iOS

- [ ] Team `VGTWPL7QUR`, Automatic signing
- [ ] `GoogleService-Info.plist` present
- [ ] Archive from `Runner.xcworkspace`
- [ ] AuthKey `.p8` not redistributed with release artifacts — [[iOS]]

## Known product gaps to communicate

- [ ] Complaint save is mocked (no API) — [[Flows/Complaint and Query Flow|Complaint Flow]]
- [ ] Payment Firestore flag unused; UI hardcodes new flow — [[Flows/Fee and Payment Flow|Fee Flow]]

## Related

- [[Handover/Vendor Guide|Vendor Guide]]
- [[Troubleshooting/Index|Troubleshooting]]

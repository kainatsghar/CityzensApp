---
title: Flutter Storage and Caching
description: SharedPreferences AppLocalData, LocalCacheManager, secure auth storage, ResultPdfCache, cached_network_image.
tags: [cityzens, flutter, storage, cache, sharedpreferences]
created: 2026-08-04
updated: 2026-08-04
owner: Cityzens Engineering
status: verified
---

# Storage and Caching

> Back to [[Home]] · [[Flutter/Index|Flutter]] · [[Diagrams/Master Architecture|Master Architecture]]

## `AppLocalData` (SharedPreferences)

Source: `lib/shared_preference/shared_preference.dart`.

Thin wrapper over `SharedPreferences`:

- `setStringPrefValue` / `getStringPrefValue`
- `setBoolPrefValue` / `getBoolPrefValue`
- `removeKeyData`

Known keys in `AppConstants`:

| Key | Constant |
|---|---|
| `userData` | `AppConstants.userDataKey` |
| `teacherProfileData` | `AppConstants.teacherProfileData` |

Also used for per-student session cache keys such as `cached_session_id_$studentId` in `StudentDashboardRepository`.

## `LocalCacheManager`

Source: `lib/services/LocalCache/local_cache_manager.dart`.

SharedPreferences-backed JSON cache with:

- Prefixes: `cityzens_cache_`, `cityzens_last_sync_`
- `saveData(key, jsonData, dataType)` — stores payload, ISO8601 last sync, and `${cacheKey}_type`
- `getData` / `getLastSyncTime` / `cacheExists` / `clearCache` / `clearAllCaches` (logout)

Consumers include `StudentDashboardRepository` (bundle TTL 15 minutes) and `ResultPdfCacheService` (index metadata).

## FlutterSecureStorage / LocalAuth

Source: `lib/services/LocalAuth/local_auth_service.dart`.

- `FlutterSecureStorage` stores saved accounts under key `saved_accounts` (`SavedAccount`: username, password, userType).
- `local_auth` (`LocalAuthentication`) for biometric gate; on missing plugin / unsupported platform, authenticate falls back to `true`.

> [!warning] Verification Required
> Directory `lib/services/SecureStorage/` exists but is **empty**. No separate SecureStorage service class was found; secure storage is implemented inside `LocalAuthService`.

## `ResultPdfCacheService`

Source: `lib/services/Results/result_pdf_cache_service.dart`.

- Writes PDF files under application documents `result_pdfs/`.
- Indexes entries via `LocalCacheManager` key `result_pdf_index` (`result_pdf_index_v1`).
- Cache key prefers `PDFResultItem.documentId`, else composite of student/session/term/class.

## `cached_network_image`

Package: `cached_network_image: ^3.4.1` in `pubspec.yaml`.

Verified usages:

- Promotion screens / dialog (`CachedNetworkImage`, `CachedNetworkImageProvider`)
- `parent_eye_on_your_child_component.dart`

`CustomUserImage` uses local file paths / assets, not `CachedNetworkImage`.

## Related

- Dashboard offline-first: [[Backend/Screen API Maps|Screen API Maps]] (`StudentDashboardRepository`)
- Push notification preference `notifications_enabled` also uses SharedPreferences (see [[Firebase/Messaging|Messaging]])

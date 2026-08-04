---
title: Flutter Networking
description: ApiBaseHelper HTTP client, headers quirk, POST-heavy AIMS+ endpoints under baseUrl/api/.
tags: [cityzens, flutter, networking, http, api]
created: 2026-08-04
updated: 2026-08-04
owner: Cityzens Engineering
status: verified
---

# Networking

> Back to [[Home]] · [[Flutter/Index|Flutter]] · [[Backend/API Client|API Client]] · [[Diagrams/Master Architecture|Master Architecture]]

Sources: `lib/network/api_base_helper.dart`, `lib/utils/app_constants.dart`.

## Base URL

```text
apiBaseURL = "$baseUrl/api/"
```

| Constant | Value (as of code) |
|---|---|
| `apiTestBaseURL` | `https://testcityzenapi.csn.edu.pk` |
| `apiLiveBaseURL` | `https://cityzenapi.csn.edu.pk` |
| Active `baseUrl` | **`apiTestBaseURL`** (`apiLiveBaseURL` assignment is commented out) |

All `ApiBaseHelper` methods request `Uri.parse('${AppConstants.apiBaseURL}$endPoint')`, so endpoints resolve under `{baseUrl}/api/{EndPoint}`.

## Client: `ApiBaseHelper`

| Method | Used by services? |
|---|---|
| `httpPostRequest` | Yes — primary path (~65 call sites under `lib/services/`) |
| `httpGetRequest` | Defined only — **no service callers** found |
| `httpPutRequest` | Defined only — **no service callers** found |
| `httpPatchRequest` | Defined only — **no service callers** found |
| `httpDeleteRequest` | Defined only — **no service callers** found |
| `httpMultipartPostRequest` | Yes — `PromotionRepository` |

Almost all API traffic is **POST**. Exception outside the helper: `StudentSubjectService` uses raw `http.post` to `SearchStudentSubjectList` (still under `apiBaseURL`).

## Headers quirk (`httpPostRequest`)

```dart
final headers = {'Authorization': 'Bearer $token'};
headers.addAll(AppConstants.appHeaders);

// debug logging uses `headers` (includes Bearer) …
response = await http.post(
  Uri.parse('${AppConstants.apiBaseURL}$endPoint'),
  headers: AppConstants.appHeaders,  // ← sent on the wire
  body: json.encode(body),
);
```

**Fact:** Authorization Bearer is built (and logged in debug) but the **outgoing** request uses only `AppConstants.appHeaders`:

```dart
{
  'Content-Type': 'application/json; charset=UTF-8',
  'Accept': 'application/json',
}
```

Auth tokens are passed in **JSON bodies** by services (e.g. `tokenId` fields), not as HTTP Authorization headers on the wire.

Optional `token` parameter on `httpPostRequest` does not change sent headers.

## Errors

Mapped in `_returnResponse` — see [[Flutter/Error Handling|Error Handling]] and [[Backend/API Client|API Client]].

## Package

Dependency: `package:http`.

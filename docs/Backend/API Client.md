---
title: Backend API Client
description: ApiBaseHelper method surface, AppConstants headers, and HTTP/status error mapping table.
tags: [cityzens, backend, api-client, http]
created: 2026-08-04
updated: 2026-08-04
owner: Cityzens Engineering
status: verified
---

# API Client

> Back to [[Home]] · [[Backend/Index|Backend]] · [[Flutter/Networking|Networking]] · [[Diagrams/Master Architecture|Master Architecture]]

Source of truth: `lib/network/api_base_helper.dart`, `lib/network/app_exceptions.dart`, `lib/utils/app_constants.dart`.

## Methods

| Method | HTTP verb | Notes |
|---|---|---|
| `httpGetRequest(endPoint)` | GET | Headers: `appHeaders`. No service callers found. |
| `httpPostRequest(endPoint, {body, token})` | POST | Primary path. See header quirk below. |
| `httpPutRequest(endPoint, {body})` | PUT | No service callers found. |
| `httpPatchRequest(endPoint, body)` | PATCH | No service callers found. |
| `httpDeleteRequest(endPoint, {body})` | DELETE | Body param unused; headers only. No service callers found. |
| `httpMultipartPostRequest(endPoint, {fields, filePath, fileField})` | POST multipart | Used by `PromotionRepository`. |

URL construction: `${AppConstants.apiBaseURL}$endPoint` → `{baseUrl}/api/{endPoint}`.

## Headers

### Sent on the wire (`AppConstants.appHeaders`)

```json
{
  "Content-Type": "application/json; charset=UTF-8",
  "Accept": "application/json"
}
```

### `httpPostRequest` logging vs send

Builds `{'Authorization': 'Bearer $token'}..addAll(appHeaders)` for **debug `log` only**; `http.post` uses **`AppConstants.appHeaders` only**. See [[Flutter/Networking|Networking]].

Multipart maps the same `appHeaders` onto the `MultipartRequest`.

## Success / error table

### Success

| Condition | Result |
|---|---|
| Status `>= 200 && < 300` | Parsed `Map<String, dynamic>` (list/primitive wrapped as `{'data': …}`) |

### HTTP errors

| Status | Exception |
|---|---|
| 400 | `BadRequestException` |
| 401 | `InvalidInputException` |
| 403 | `UnAuthorizedException` |
| 404 | `FetchDataException` |
| 500 / other non-2xx | `FetchDataException` |

Message preference: `jsonResponse['message']` → `jsonResponse['Message']` → `AppConstants.exceptionMessage`.

### Client-side failures

| Error | Exception / message |
|---|---|
| `SocketException` | `FetchDataException` → no internet message |
| `FormatException` | bad response format |
| `TimeoutException` | slow internet |
| other | generic exception message |

Full hierarchy: [[Flutter/Error Handling|Error Handling]].

## Auth pattern (client)

Session tokens (`tokenId`) are included in **request bodies** by services/models, not as an Authorization header on the wire (given the current `httpPostRequest` implementation).

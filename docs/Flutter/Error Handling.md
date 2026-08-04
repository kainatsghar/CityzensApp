---
title: Flutter Error Handling
description: AppExceptions hierarchy and HTTP status mapping in ApiBaseHelper._returnResponse.
tags: [cityzens, flutter, errors, exceptions, networking]
created: 2026-08-04
updated: 2026-08-04
owner: Cityzens Engineering
status: verified
---

# Error Handling

> Back to [[Home]] · [[Flutter/Index|Flutter]] · [[Backend/API Client|API Client]] · [[Diagrams/Master Architecture|Master Architecture]]

Sources: `lib/network/app_exceptions.dart`, `lib/network/api_base_helper.dart`, `lib/utils/app_constants.dart`.

## Exception hierarchy

```text
AppException (base, message via toString)
├── FetchDataException
├── BadRequestException
├── UnAuthorizedException
└── InvalidInputException
```

## Transport / parse failures

Caught around HTTP calls; all throw `FetchDataException` with `AppConstants` messages:

| Caught | Message constant |
|---|---|
| `SocketException` | `noInternetMsg` |
| `FormatException` | `badResponseFormat` |
| `TimeoutException` | `slowInternetMsg` |
| other | `exceptionMessage` |

## HTTP status mapping (`_returnResponse`)

| Status | Exception | Message source |
|---|---|---|
| 200–299 | *(success — returns JSON map)* | — |
| 400 | `BadRequestException` | `message` / `Message` / fallback |
| 401 | `InvalidInputException` | same |
| 403 | `UnAuthorizedException` | same |
| 404 | `FetchDataException` | same |
| 500 / default | `FetchDataException` | same |

Non-map JSON bodies are wrapped as `{'data': decoded}`. Empty / undecodable bodies yield `{}` before status checks.

## UI / provider handling

Providers typically catch exceptions and show snackbars or dialogs via custom widgets (`CustomSnackbar`, `ShowError`, loading dialogs). There is no global Flutter `ErrorWidget` override beyond Crashlytics `FlutterError.onError` (see [[Firebase/Crashlytics|Crashlytics]]).

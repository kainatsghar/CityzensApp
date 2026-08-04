---
title: Backend Index
description: External AIMS+ ERP REST API consumed by the Flutter client — not hosted in this repository.
tags: [cityzens, backend, aims, api]
created: 2026-08-04
updated: 2026-08-04
owner: Cityzens Engineering
status: verified
---

# Backend

> Back to [[Home]] · [[Diagrams/Master Architecture|Master Architecture]]

## Scope

The Cityzens Flutter app talks to an **external AIMS+ ERP REST API**. Backend server code is **not** in this repository.

Client configuration (`lib/utils/app_constants.dart`):

| Environment | Host |
|---|---|
| Test (active) | `https://testcityzenapi.csn.edu.pk` |
| Live | `https://cityzenapi.csn.edu.pk` |

API root used by the client: `{host}/api/` (`AppConstants.apiBaseURL`).

## Subpages

| Page | Topic |
|---|---|
| [[Backend/API Client\|API Client]] | `ApiBaseHelper` methods, headers, error table |
| [[Backend/Screen API Maps\|Screen API Maps]] | Representative Screen → Provider → Service → Endpoint → Model maps |

## Related client docs

- [[Flutter/Networking|Networking]]
- [[Flutter/Error Handling|Error Handling]]
- [[API/Index|API Reference]] (legacy/partial endpoint notes)

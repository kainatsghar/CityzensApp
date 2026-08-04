---
title: Result Flow
description: ResultsProvider PDFResults and AllPDFResults with ResultPdfDownloadService caching.
tags: [cityzens, diagrams, results, pdf]
created: 2026-08-04
updated: 2026-08-04
owner: Cityzens Engineering
status: verified
---

# Result Flow

> Back to [[Home]] · [[Diagrams/Index|Diagrams]] · [[Flows/Term Results Flow|Term Results Flow]]

Term and archive PDF results via `ResultsProvider`, ERP endpoints `PDFResults` / `AllPDFResults`, and local PDF download/cache.

## Mermaid

```mermaid
flowchart TD
  UI1["ResultsScreen / AcademicTermScreen"]
  UI2["AllPDFResultsScreen"]
  RP["ResultsProvider"]
  RS["ResultService static"]
  PDF["POST PDFResults<br/>userName · termId · academicYearId"]
  All["POST AllPDFResults<br/>studentId"]
  Parse1["ResultsResponse · PDFResults list"]
  Parse2["AllPDFResultsResponse · PDFResults"]
  NL["notifyListeners"]
  Cons["Consumer rebuild"]
  DL["downloadResultPdf"]
  RPD["ResultPdfDownloadService.download"]
  Cache["ResultPdfCacheService<br/>LocalCacheManager index + files"]
  Open["open_filex / viewer"]

  UI1 --> RP --> RS --> PDF --> Parse1 --> NL --> Cons
  UI2 --> RP --> RS --> All --> Parse2 --> NL
  Cons --> DL --> RPD --> Cache --> Open
  Cons --> Open
```

## API surface

| Method | Endpoint | Request model | Provider entry |
|---|---|---|---|
| `ResultService.resultsRequest` | `PDFResults` | `ResultsRequest` | Term-scoped result load |
| `ResultService.allPDFResultsRequest` | `AllPDFResults` | `AllPDFResultsRequest` | `loadAllPDFResults()` |

Evidence: `lib/services/Results/result_service.dart`.

## Download / cache

1. `ResultsProvider.downloadResultPdf(item)` marks `downloadingPdfKeys`, `notifyListeners`
2. `ResultPdfDownloadService.download` → network file + `ResultPdfCacheService.save`
3. `ResultPdfCacheService` keeps an index via `LocalCacheManager` and files on disk
4. `openCachedResultPdf` / `OpenFilex` for offline open
5. Analytics: `AppAnalyticsService.logResultPdfEvent`

Routes: `AppNavRoutes.resultsRoute`, `academicTermRoute`, `allPDFResultsRoute` (`RouteGenerator`).

## Key files

| File | Role |
|---|---|
| `lib/provider/Results/results_provider.dart` | State + download orchestration |
| `lib/services/Results/result_service.dart` | ERP POSTs |
| `lib/services/Results/result_pdf_download_service.dart` | Download pipeline |
| `lib/services/Results/result_pdf_cache_service.dart` | Disk + index cache |
| `lib/screens/Student/ResultScreen/*` | UI |
| `lib/components/ResultsComponents/*` | List / eye detail |

## Related pages

- [[Architecture/State Management|State Management]] · [[Architecture/Provider Map|Provider Map]]
- [[API/Index|API Catalog]] · [[Flows/Term Results Flow|Term Results Flow]]

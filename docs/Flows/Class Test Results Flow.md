---
title: Class Test Results Flow
description: User journey documentation: Class Test Results Flow.
tags: [cityzens, flows]
created: 2026-08-04
updated: 2026-08-04
owner: Cityzens Engineering
status: verified
---

# Class Test Results Flow

## Overview

Teachers upload class test results (up to 3 tests per term per class/section). Students view their marks per subject. This flow is distinct from Term Results which come from the AIMS+ ERP.

## Teacher Flow: Enter Results

```mermaid
graph TD
    A["Teacher Dashboard"] --> B["Tap 'Class Test Results'"]
    B --> C["TeacherClassTestResultScreen"]
    C --> D["Select class/section"]
    D --> E["Select test number<br/>(Test 1, Test 2, or Test 3)"]
    E --> F["TeacherAddClassResultScreen"]
    F --> G["Student list loaded"]
    G --> H["Enter marks per student<br/>per subject"]
    H --> I["Input validation<br/>(numeric, within range)"]
    I --> J["Submit results"]
    J --> K["ClassTestResultProvider.saveResults()"]
    K -->|Success| L["SnackBar: Results Saved"]
    K -->|Failure| M["SnackBar: Error"]
```

## Student Flow: View Results

```mermaid
graph TD
    A["Dashboard"] --> B["Tap 'Class Test Results'"]
    B --> C["StudentClassResultScreen"]
    C --> D["loadClassTestResults()"]
    D --> E["Subject-wise results<br/>Test 1 / Test 2 / Test 3"]
    E --> F["View marks + comments"]
```

## Key Files

| File | Purpose |
|---|---|
| `provider/ClassTestResult/class_test_result_provider.dart` | Test result state |
| `screens/Teacher/TeacherClassTestResultScreen/` | Teacher result entry |
| `screens/Student/StudentClassTestResultScreen/` | Student result view |
| `services/ClassTestResult/class_test_result_service.dart` | API calls |

## Related Pages

- [[Teacher Flow]]
- [[Student Flow]]
- [[Term Results Flow]]

---
title: Eye on Your Child Flow
description: User journey documentation: Eye on Your Child Flow.
tags: [cityzens, flows]
created: 2026-08-04
updated: 2026-08-04
owner: Cityzens Engineering
status: verified
---

# Eye on Your Child Flow

## Overview

"Eye on Your Child" is an early-years feature (typically Grades 1–4) where teachers share student activity updates with photos. Parents receive these updates and can view them in real-time.

## Teacher Flow: Create Activity Update

```mermaid
graph TD
    A["Teacher Dashboard"] --> B["Tap 'Eye on Your Child'"]
    B --> C["EyeOnYourChildScreen"]
    C --> D["loadEyeOnChildConfig()<br/>EyeOnYourChildService"]
    D --> E["EyeOnYourChildResponse:<br/>• studentDetails (list)<br/>• studentUpdateDetails (update types)"]
    
    E --> F["Auto-select first student<br/>(if none selected)"]
    F --> G["Auto-select first update type<br/>(if none selected)"]
    G --> H["Select specific student<br/>(dropdown/chips)"]
    H --> I["Select update type<br/>(dropdown/chips)"]
    I --> J["Upload photos<br/>(up to 3 images)"]
    J --> K["Fill form details"]
    K --> L["submitEyeOnChildRecord()"]
    L --> M["AddEyeOnYourChildService<br/>.saveStudentUpdatesForParent()"]
    M -->|Success| N["Reload config → goBack()<br/>SnackBar: Record Added"]
    M -->|Failure| O["SnackBar: Error"]
```

## Photo Upload

The system supports up to **3 images** per activity update:

```mermaid
graph TD
    A["Tap 'Upload'"] --> B["FilePicker.pickFiles()<br/>allowMultiple: true<br/>type: FileType.image"]
    B --> C{"> 3 images?"}
    C -->|Yes| D["SnackBar: 'You can only<br/>select up to 3 images'"]
    C -->|No| E["For each file:"]
    E --> F["File → readAsBytes()<br/>→ base64Encode()"]
    F --> G["Store:<br/>fileName1/2/3<br/>base64String1/2/3"]
```

- Images are encoded as base64 strings and sent in the request body
- Each slot (`fileName1`/`base64String1`, etc.) maps to one image
- `removeAttachment(index)` removes a specific slot and reassigns the remaining

## Parent Flow: View Activity Updates

```mermaid
graph TD
    A["Parent Dashboard"] --> B["Tap 'Eye on Your Child'"]
    B --> C["ParentEyeOnYourChildScreen"]
    C --> D["loadStudentUpdates()<br/>ParentEyeOnYourChildService"]
    D --> E["ParentEyeOnYourChildResponse:<br/>• fileList (with filePath1/2/3)"]
    E --> F["Display activity feed"]
    F --> G["View photos:<br/>filePath1, filePath2, filePath3"]
    G --> H["Read teacher notes"]
```

## Key Files

| File | Purpose |
|---|---|
| `provider/EyeOnYourChild/eye_on_your_child_provider.dart` | Teacher + parent state |
| `screens/Teacher/EyeOnYourChildScreen/` | Teacher create view |
| `screens/Parent/ParentEyeOnYourChildScreen/` | Parent view |
| `services/AddEyeOnYourChild/add_eye_on_your_child_service.dart` | Submit update API |
| `services/EyeOnYourChild/eye_on_your_child_service.dart` | Config/student list API |
| `services/ParentEyeOnYourChild/parent_eye_on_your_child_service.dart` | Parent view API |

## Related Pages

- [[Teacher Flow]]
- [[Parent Flow]]

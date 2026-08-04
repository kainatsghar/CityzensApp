---
title: Student Flow
description: User journey documentation: Student Flow.
tags: [cityzens, flows]
created: 2026-08-04
updated: 2026-08-04
owner: Cityzens Engineering
status: verified
---

# Student Flow

## Dashboard

The Student Dashboard (`StudentDashboardScreen`) features:

1. **Profile Card** — Premium card with name, class, campus, attendance gauge
2. **Session Attendance** — Circular progress indicator (tappable → attendance screen)
3. **Action Grid** — Tiles for: Diary, Assignment, Results, Fee, Library, Timetable, Events, Surveys

## Core Flows

### 1. Attendance — Standard Students

```mermaid
graph TD
    A["Dashboard"] --> B["Tap attendance section"]
    B --> C["StudentAttendanceScreen"]
    C --> D["FutureBuilder: loadAttendance()"]
    D -->|Loading| E["CustomLoader"]
    D -->|Done| F["StudentAttendanceComponent"]
    F --> G["Monthly Calendar<br/>(table_calendar)"]
    F --> H["Pie Chart Summary"]
    F --> I["Legend Chips:<br/>Present / Absent / Leave"]
    G -->|Tap month arrow| J["reloadAttendance(newDate)"]
    J -->|Loading dialog| K["Fetch new month data"]
    K --> G
```

### 2. Attendance — A-Level Students (Grade ID 19 or 20)

```mermaid
graph TD
    A["Dashboard"] --> B["Tap attendance section"]
    B --> C{"Grade ID = 19 or 20?"}
    C -->|No| D["StudentAttendanceScreen<br/>(standard flow)"]
    C -->|Yes| E["StudentAlevelAttendanceScreen"]
    E --> F["FutureBuilder: loadInitialData()"]
    F -->|Loading| G["AttendanceShimmer"]
    F -->|Done| H["StudentAttendanceComponent"]
    
    subgraph loadInitialData
        I["subjects.isEmpty?"] -->|Yes| J["loadAttendanceSubjects()<br/>(API call)"]
        J --> K["Cache in provider.subjects"]
        I -->|No| K["Use cached subjects"]
        K --> L["Auto-select first subject"]
        L --> M["loadAttendance()<br/>for selected subject"]
    end
    
    H --> N["Horizontal Subject Chips<br/>(scrollable)"]
    H --> O["Calendar + Pie Chart"]
    N -->|Tap different subject| P["setSelectedSubject(id)"]
    P -->|Loading dialog| Q["Fetch attendance<br/>for new subject"]
    Q --> O
```

**Key Design Decisions**:
- Subject list is **session-cached** — only fetched once, then reused
- First subject is **auto-selected** on screen entry
- No intermediate subject selection screen — direct to calendar
- Subject switching via horizontal chips at the top

### 3. Homework Diary

```mermaid
graph TD
    A["Dashboard"] --> B["Tap 'Diary'"]
    B --> C["StudentDiaryScreen"]
    C --> D["Grouped list by date"]
    D --> E["Each entry shows:<br/>Teacher, Subject, Description"]
    E --> F["Download attachment<br/>(if available)"]
```

- Homework auto-hides after 7 days
- All homework for the same date grouped under a single header

### 4. Term Results (from AIMS+ ERP)

```mermaid
graph TD
    A["Dashboard"] --> B["Tap 'Results'"]
    B --> C["ResultsScreen"]
    C --> D["Select Academic Session"]
    D --> E["AcademicTermScreen"]
    E --> F["Select Term"]
    F --> G["Subject-wise marks + grades"]
    G --> H["Teacher comments<br/>Overall grade<br/>Performance indicators"]
```

### 5. Fee & Payment

```mermaid
graph TD
    A["Dashboard"] --> B["Tap 'Fee'"]
    B --> C["FeeChallanScreen"]
    C --> D["Two tabs"]
    D --> E["Outstanding Challans<br/>(from ERP)"]
    D --> F["Receipts<br/>(last 5 payments)"]
    E -->|Tap challan| G["ChallanPaymentScreen<br/>(WebView)"]
    G --> H["Secure payment gateway<br/>billing.thecityschool.edu.pk"]
```

### 6. Library

```mermaid
graph TD
    A["Dashboard"] --> B["Tap 'Library'"]
    B --> C["LibraryScreen"]
    C --> D["Two tabs"]
    D --> E["Issued Books<br/>Title, Due Date, Fine"]
    D --> F["Notifications<br/>(Overdue Alerts)"]
```

### 7. Student Profile

- Read-only view of ERP data
- Fields: Name, Roll Number, Class/Section, Campus, Contact, DOB
- **Students cannot edit** their contact information (enforced by role check)
- Profile photo: local-only (stored via `SharedPreferences` file path)

### 8. Other Student Features

| Feature | Screen | Notes |
|---|---|---|
| Classwork/Assignments | `StudentAssignmentScreen` | Same pattern as Diary |
| Class Test Results | `StudentClassResultScreen` | View Test 1/2/3 marks |
| Timetable | Read-only 9×5 grid | Created by teacher |
| School Events | `StudentSchoolEventScreen` | Published events |
| Surveys | `StudentSurveyScreen` | Complete assigned surveys |
| Notifications | `NotificationScreen` | School announcements |

## Key Files

| File | Purpose |
|---|---|
| `screens/Student/StudentDashboardScreen/` | Dashboard + profile card |
| `provider/StudentDashboard/student_dashboard_provider.dart` | Dashboard state + multi-child |
| `provider/StudentAttendance/student_attendance_provider.dart` | Standard attendance |
| `provider/StudentAttendance/student_alevel_attendance_provider.dart` | A-Level attendance + caching |
| `provider/StudentProfile/student_profile_provider.dart` | Profile data + session cache |

## Related Pages

- [[Authentication Flow]]
- [[Teacher Flow]]
- [[Parent Flow]]

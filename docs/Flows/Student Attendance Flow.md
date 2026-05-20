# Student Attendance Flow

## Overview

Students view their attendance history through a monthly calendar with color-coded indicators and a pie chart summary. Standard students see a direct calendar; A-Level students (Grade 19/20) get a single-screen flow with subject chips and session caching.

## Standard Attendance (Non A-Level)

```mermaid
graph TD
    A["StudentDashboardScreen"] --> B["Tap attendance card"]
    B --> C["StudentAttendanceScreen"]
    C --> D["FutureBuilder: loadAttendance()"]
    D -->|Loading| E["CustomLoader"]
    D -->|Done| F["StudentAttendanceComponent"]
    F --> G["Monthly Calendar<br/>(table_calendar)"]
    F --> H["Pie Chart<br/>(fl_chart)"]
    F --> I["Legend Chips:<br/>Present 🟢 / Absent 🔴 / Leave 🟡"]
    G -->|Month arrow| J["reloadAttendance(newMonth)"]
    J -->|Loading dialog| K["API: GetMonthlyAttendance"]
    K --> G
```

## A-Level Attendance (Grade 19/20)

```mermaid
graph TD
    A["StudentDashboardScreen"] --> B["Tap attendance card"]
    B --> C{"Grade ID = 19 or 20?"}
    C -->|No| D["Standard flow above"]
    C -->|Yes| E["StudentAlevelAttendanceScreen"]
    
    E --> F["FutureBuilder: loadInitialData()"]
    F -->|Loading| G["AttendanceShimmer<br/>(skeleton: chips + chart + calendar)"]
    F -->|Error| H["ShowError"]
    F -->|Done| I["StudentAttendanceComponent<br/>with subject chips"]
    
    subgraph "loadInitialData() — Sequential"
        J["subjects.isEmpty?"] -->|Yes| K["loadAttendanceSubjects()<br/>(API call)"]
        K --> L["Cache in provider.subjects"]
        J -->|No| L["Use cached subjects"]
        L --> M["Auto-select first subject<br/>(selectedSubjectId = subjects[0].SubjectId)"]
        M --> N["loadAttendance()<br/>for selected subject"]
    end
    
    I --> O["Horizontal Subject Chips<br/>(scrollable, animated)"]
    I --> P["Calendar + Pie Chart + Legend"]
    
    O -->|Tap different chip| Q["setSelectedSubject(newId)"]
    Q --> R["Loading dialog"]
    R --> S["loadAttendance(newSubjectId)"]
    S --> P
```

## Subject Chip Design

The subject chips are horizontal `AnimatedContainer` widgets:

| State | Style |
|---|---|
| **Active** | `primaryBlue` background, white text, elevated shadow |
| **Inactive** | White background, `primaryBlue` text, subtle border |
| **Transition** | 200ms `AnimatedContainer` for smooth switching |

## Session Caching

- Subjects are fetched **once per session** and stored in `StudentALevelAttendanceProvider.subjects`
- Subsequent screen visits skip the API call and use the cached list
- Only the attendance calendar data is re-fetched on subject switch

## Shimmer Loading

`AttendanceShimmer` displays a skeleton layout matching the real content:
1. **Subject chips row** — 4 rounded placeholder containers
2. **Monthly summary** — 250px tall placeholder
3. **Calendar** — 350px tall placeholder

Uses the same `ShaderMask` + `LinearGradient` animation pattern as `DashboardShimmer`.

## Calendar Indicators

| Status | Color | Indicator |
|---|---|---|
| Present | `#10B981` (green) | Green dot/highlight |
| Absent | `#EF4444` (red) | Red dot/highlight |
| Leave | `#F59E0B` (amber) | Yellow dot/highlight |

## Key Files

| File | Purpose |
|---|---|
| `provider/StudentAttendance/student_attendance_provider.dart` | Standard attendance state |
| `provider/StudentAttendance/student_alevel_attendance_provider.dart` | A-Level flow + subject caching |
| `screens/Student/StudentAttendanceScreen/student_attendance_screen.dart` | Standard attendance screen |
| `screens/Student/StudentAttendanceScreen/student_alevel_attendance_screen.dart` | A-Level attendance screen |
| `components/StudentAttendanceComponents/` | Calendar, pie chart, subject chips, legend |
| `custom_widgets/ShimmerEffect/attendance_shimmer.dart` | Skeleton loading effect |

## Related Pages

- [[Mark Attendance Flow]]
- [[Student Flow]]

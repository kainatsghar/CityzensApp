# Teacher Flow

## Dashboard

The Teacher Dashboard (`TeacherDashboardScreen`) is the central hub with:

1. **Profile Strip** — Glassmorphic card showing teacher name, designation, campus
2. **Smart Class & Section Card** — Unified selection hub for the active section/subject
3. **Action Grid** — Quick-access tiles for all teacher features
4. **Pull-to-Refresh** — Single gesture refreshes all dashboard data

## Core Flows

### 1. Mark Attendance

```mermaid
graph TD
    A["Teacher Dashboard"] --> B["Tap 'Mark Attendance'"]
    B --> C{"Section<br/>selected?"}
    C -->|No| D["SnackBar: Select section first"]
    C -->|Yes| E{"A-Level class?<br/>(Grade 19/20)"}
    E -->|Yes| F{"Subject<br/>selected?"}
    F -->|No| G["SnackBar: Select subject first"]
    F -->|Yes| H["AttendanceListScreen"]
    E -->|No| H
    H --> I["Student list loaded"]
    I --> J["Mark each student:<br/>P / A / L / U"]
    J --> K["View live pie chart"]
    K --> L["Submit attendance"]
    L --> M["Confirmation"]
```

**Key Provider**: `MarkAttendanceProvider`
- Holds student list, attendance status per student
- Live pie chart updates as teacher marks
- 4 statuses: Present, Absent, Leave, Unreconciled

### 2. Homework / Classwork / Circulars (Academic Hub)

```mermaid
graph TD
    A["Teacher Dashboard"] --> B["Tap Homework/Classwork/Circular tile"]
    B --> C["TeacherAcademicHubScreen"]
    C --> D["Tabbed view: Homework | Classwork | Circulars"]
    D --> E["View existing records"]
    E --> F["Tap FAB to create new"]
    F --> G["AddDiaryScreen / AddAssignmentScreen / AddCircularScreen"]
    G --> H["Select class/section"]
    H --> I["Enter title + description"]
    I --> J["Optional file attachment"]
    J --> K["Submit"]
    K --> L["Confirmation"]
```

- FAB dynamically changes context based on active tab
- Teachers only see their own created content
- Edit mode: pass existing record as route argument
- Homework auto-archives after 7 days

### 3. Class Test Results

```mermaid
graph TD
    A["Teacher Dashboard"] --> B["Tap 'Class Test Results'"]
    B --> C["TeacherClassTestResultScreen"]
    C --> D["Select class/section"]
    D --> E["Select Test (1, 2, or 3)"]
    E --> F["TeacherAddClassResultScreen"]
    F --> G["Enter marks per student per subject"]
    G --> H["Input validation"]
    H --> I["Submit results"]
    I --> J["Available on student portal"]
```

### 4. Eye on Your Child (Early Years)

```mermaid
graph TD
    A["Teacher Dashboard"] --> B["Tap 'Eye on Your Child'"]
    B --> C["EyeOnYourChildScreen"]
    C --> D["Select student(s)"]
    D --> E["Add descriptive notes"]
    E --> F["Upload photos (up to 3)"]
    F --> G["Submit activity update"]
    G --> H["Parent notified + sees in real time"]
```

### 5. Timetable

```mermaid
graph TD
    A["Teacher Dashboard"] --> B["Tap 'Timetable'"]
    B --> C["Select class/section"]
    C --> D["TeacherTimeTableScreen"]
    D --> E["9x5 grid<br/>(9 periods × Mon-Fri)"]
    E --> F["Enter subject abbreviations"]
    F --> G["Save"]
```

## Navigation Guards

The dashboard validates prerequisites before navigation:
- **Section-dependent screens** (Attendance, Timetable, Academic Hub): Requires active section selection
- **A-Level subject-dependent screens**: Requires subject selection in addition to section
- Clear SnackBar feedback when prerequisites are missing

## Key Files

| File | Purpose |
|---|---|
| `screens/Teacher/TeacherDashboardScreen/` | Dashboard screen + components |
| `provider/MarkAttendance/mark_attendance_provider.dart` | Attendance marking state |
| `provider/Diary/diary_provider.dart` | Homework management |
| `provider/Assignment/assignment_provider.dart` | Classwork management |
| `provider/Circular/circular_provider.dart` | Circular management |
| `provider/ClassTestResult/class_test_result_provider.dart` | Test results |
| `provider/EyeOnYourChild/eye_on_your_child_provider.dart` | Activity feed |
| `provider/TimeTable/timetable_provider.dart` | Timetable CRUD |

## Related Pages

- [[Authentication Flow]]
- [[Student Flow]]
- [[Parent Flow]]

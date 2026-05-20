# Feature Status Matrix

## Legend

- ✅ **Complete** — Feature is fully implemented and functional
- 🚧 **In Progress** — Partially implemented or being actively worked on
- 📋 **Planned** — Designed but not yet started
- ❌ **Blocked** — Cannot proceed due to a dependency

---

## Teacher Features

| Feature | Status | Provider | Notes |
|---|---|---|---|
| Dashboard | ✅ | — | Sliver-based, glassmorphic, premium |
| Profile View | ✅ | `TeacherProfileProvider` | Read-only ERP data |
| Mark Attendance | ✅ | `MarkAttendanceProvider` | P/A/L/U, pie chart, A-Level subjects |
| Mark Unidentified | ✅ | `MarkUnverifiedProvider` | |
| Homework (Diary) | ✅ | `DiaryProvider` | Create, edit, 7-day auto-archive |
| Classwork (Assignment) | ✅ | `AssignmentProvider` | Create, edit, attachments |
| Circulars | ✅ | `CircularProvider` | Create, edit |
| Academic Hub | ✅ | — | Unified tabbed view for Diary/Assignment/Circular |
| Class Test Results | ✅ | `ClassTestResultProvider` | Test 1/2/3, input validation |
| Eye on Your Child | ✅ | `EyeOnYourChildProvider` | Early years only, photos + notes |
| Timetable | ✅ | `TimeTableProvider` | 9×5 grid CRUD |
| Surveys | ✅ | `SurveyProvider` | Create/manage |
| School Events | ✅ | `SchoolEventProvider` | Create/publish |
| Edit/Delete Homework | ✅ | `DiaryProvider` | Via route arguments |
| Edit/Delete Classwork | ✅ | `AssignmentProvider` | Via route arguments |
| Edit/Delete Circulars | ✅ | `CircularProvider` | Via route arguments |

## Student Features

| Feature | Status | Provider | Notes |
|---|---|---|---|
| Dashboard | ✅ | `StudentDashboardProvider` | Premium profile card, multi-child |
| Profile | ✅ | `StudentProfileProvider` | Read-only for students, session cached |
| Attendance (Standard) | ✅ | `StudentAttendanceProvider` | Calendar + pie chart |
| Attendance (A-Level) | ✅ | `StudentALevelAttendanceProvider` | Auto-select, subject chips, session cache |
| Homework Diary | ✅ | `DiaryProvider` | Date-grouped, 7-day visibility |
| Assignments | ✅ | `AssignmentProvider` | Date-grouped |
| Term Results | ✅ | `ResultsProvider` | From AIMS+ ERP |
| Class Test Results | ✅ | `ClassTestResultProvider` | View Test 1/2/3 |
| Fee & Payment | ✅ | `FeeChallanProvider` | WebView payment gateway |
| Library | ✅ | `LibraryProvider` | From AIMS+ ERP |
| Timetable (Read-Only) | ✅ | `TimeTableProvider` | |
| School Events | ✅ | `SchoolEventProvider` | |
| Surveys | ✅ | `SurveyProvider` | |
| Notifications | 🚧 | `NotificationProvider` | Circular viewing partial |
| Individual Education Plan | ✅ | — | Specialized screen |

## Parent Features

| Feature | Status | Provider | Notes |
|---|---|---|---|
| Multi-Child Selection | ✅ | `StudentDashboardProvider` | Avatar chips, seamless switching |
| All Student Features | ✅ | — | Shared with student portal |
| Profile Editing | ✅ | `StudentProfileProvider` | Parents can edit, students cannot |
| Eye on Your Child | ✅ | `EyeOnYourChildProvider` | View teacher updates |
| Complaint & Query | ✅ | `ComplaintQueryProvider` | Categorized submissions |
| Appointment Booking | 🚧 | `AppointmentProvider` | UI exists, backend integration ongoing |
| Withdrawal Request | 🚧 | `WithdrawalRequestProvider` | UI exists, backend integration ongoing |
| Surveys | ✅ | `SurveyProvider` | Parent-specific surveys |

## Shared / Platform Features

| Feature | Status | Notes |
|---|---|---|
| Firebase Push Notifications | ✅ | FCM + local notifications |
| Firebase Crashlytics | ✅ | Error tracking |
| Firebase Analytics | ✅ | Usage tracking |
| Firebase Remote Config | ✅ | Feature flags, API URL |
| App Update Guard | ✅ | `upgrader` package |
| Offline Detection | ✅ | `connectivity_plus` |
| About Us | ✅ | Navigation drawer |
| App Feedback | ✅ | Navigation drawer |
| Change Password | ✅ | Navigation drawer |
| Forgot Password | ✅ | OTP-based recovery |
| Registration | ✅ | New user onboarding |

## Related Pages

- [[Flows/Teacher Flow|Teacher Flow]]
- [[Flows/Student Flow|Student Flow]]
- [[Flows/Parent Flow|Parent Flow]]

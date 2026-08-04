---
title: Feature Status Matrix
description: Code-verified feature status for Teacher, Student, Parent, and platform modules at 2.0.0+89.
tags: [cityzens, features, status]
created: 2026-08-04
updated: 2026-08-04
owner: Cityzens Engineering
status: verified
---

# Feature Status Matrix

> Back to [[Home]] · App version **2.0.0+89** (`pubspec.yaml`) · [[Flows/Index|Flows]]

## Legend

- ✅ **Complete** — Implemented and API-wired (as verified in code)
- 🚧 **Incomplete / mocked** — UI present but critical path not calling API
- 📋 **Planned** — Designed but not yet started
- ❌ **Blocked** — Cannot proceed due to a dependency

---

## Teacher Features

| Feature | Status | Provider | Notes |
|---|---|---|---|
| Dashboard | ✅ | — | Sliver-based, glassmorphic |
| Profile View | ✅ | `TeacherProfileProvider` | Read-only ERP data |
| Mark Attendance | ✅ | `MarkAttendanceProvider` | P/A/L/U, pie chart, A-Level subjects |
| Mark Unidentified | ✅ | `MarkUnverifiedProvider` | |
| Homework (Diary) | ✅ | `DiaryProvider` | Create, edit, 7-day auto-archive |
| Classwork (Assignment) | ✅ | `AssignmentProvider` | Create, edit, attachments |
| Circulars | ✅ | `CircularProvider` | Create, edit |
| Academic Hub | ✅ | — | Unified tabbed Diary/Assignment/Circular |
| Class Test Results | ✅ | `ClassTestResultProvider` | Test 1/2/3 |
| Eye on Your Child | ✅ | `EyeOnYourChildProvider` | Early years, photos + notes |
| Timetable | ✅ | `TimeTableProvider` | 9×5 grid CRUD |
| Surveys | ✅ | `SurveyProvider` | |
| School Events | ✅ | `SchoolEventProvider` | |
| Edit/Delete Homework | ✅ | `DiaryProvider` | Via route arguments |
| Edit/Delete Classwork | ✅ | `AssignmentProvider` | Via route arguments |
| Edit/Delete Circulars | ✅ | `CircularProvider` | Via route arguments |

## Student Features

| Feature | Status | Provider | Notes |
|---|---|---|---|
| Dashboard | ✅ | `StudentDashboardProvider` | Multi-child aware |
| Profile | ✅ | `StudentProfileProvider` | Read-only for students |
| Attendance (Standard) | ✅ | `StudentAttendanceProvider` | Calendar + pie chart |
| Attendance (A-Level) | ✅ | `StudentALevelAttendanceProvider` | Subject chips, session cache |
| Homework Diary | ✅ | `DiaryProvider` | Date-grouped |
| Assignments | ✅ | `AssignmentProvider` | Date-grouped |
| Term Results | ✅ | `ResultsProvider` | `PDFResults` |
| Result PDF archive | ✅ | `ResultsProvider` | `AllPDFResults` + download service |
| Class Test Results | ✅ | `ClassTestResultProvider` | View Test 1/2/3 |
| Fee & Payment | ✅ | `FeeChallanProvider` | WebView; pay flag hardcoded true |
| Library | ✅ | `LibraryProvider` | AIMS+ ERP |
| Timetable (Read-Only) | ✅ | `TimeTableProvider` | |
| School Events | ✅ | `SchoolEventProvider` | |
| Surveys | ✅ | `SurveyProvider` | |
| Notifications | ✅ | `NotificationProvider` | FCM + `POST Notifications` groups |
| Individual Education Plan | ✅ | — | Specialized screen |

## Parent Features

| Feature | Status | Provider | Notes |
|---|---|---|---|
| Multi-Child Selection | ✅ | `StudentDashboardProvider` | Avatar chips |
| All Student Features | ✅ | — | Shared student portal |
| Profile Editing | ✅ | `StudentProfileProvider` | Parents can edit contact fields |
| Eye on Your Child | ✅ | `EyeOnYourChildProvider` | View teacher updates |
| Complaint & Query | 🚧 | `ComplaintQueryProvider` | **Save mocked** — API call commented; load uses `GetWithdrawalReasons` |
| Appointment Booking | ✅ | `AppointmentProvider` | `submitAppointment` → `AddAppointmentService` → `POST SaveMeeting` |
| Withdrawal Request | ✅ | `WithdrawalRequestProvider` | `saveWithdrawalRequest` → `AddWithdrawalRequestService` → `POST SaveWithdrawalRequest` |
| Surveys | ✅ | `SurveyProvider` | Parent-specific surveys |

## Shared / Platform Features

| Feature | Status | Notes |
|---|---|---|
| Firebase Push Notifications | ✅ | FCM + local notifications + tap routing |
| Notifications inbox API | ✅ | `NotificationService` → `Notifications` |
| Firebase Crashlytics | ✅ | |
| Firebase Analytics | ✅ | |
| Firebase Remote Config | 🚧 | `_initRemoteConfig()` **commented out** in `FirebaseMaster` |
| App Update Guard | ✅ | `upgrader` + `AppConstants.appVersion` |
| Offline Detection | ✅ | `connectivity_plus` |
| Launch promotions | ✅ | `PromotionRepository` / splash gate |
| About Us / Feedback / Change Password / Forgot Password / Registration | ✅ | Navigation drawer / auth screens |

## Related Pages

- [[Flows/Index|Flows]]
- [[Flows/Complaint and Query Flow|Complaint and Query Flow]]
- [[Flows/Notification Flow|Notification Flow]]
- [[Flows/Fee and Payment Flow|Fee and Payment Flow]]
- [[Architecture/Provider Map|Provider Map]]

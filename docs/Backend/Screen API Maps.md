---
title: Screen API Maps
description: Verified Screen→Provider→Service→Endpoint→Model maps for Login, Mark Attendance, Fee Payment, Student Dashboard, Diary.
tags: [cityzens, backend, api-maps, providers, services]
created: 2026-08-04
updated: 2026-08-04
owner: Cityzens Engineering
status: verified
---

# Screen API Maps

> Back to [[Home]] · [[Backend/Index|Backend]] · [[Diagrams/Master Architecture|Master Architecture]]

Representative maps verified from Dart call sites. Endpoint path is relative to `{baseUrl}/api/`. Method is POST unless noted.

---

## 1. Login

| Layer | Artifact |
|---|---|
| Screen | `LoginScreen` (`lib/screens/LoginScreen/`) |
| Provider | `LoginProvider` |
| Service | `LoginService.loginRequest` |
| Endpoint | `Auth` |
| Request model | `LoginRequest` (username, password, userType, fcmToken, iosFcmToken, isIOSDevice) |
| Response model | `LoginResponse` |

Post-success: persists user via SharedPreferences / `LocalDataProvider`; `AppAnalyticsService.logLogin`; optional `LocalAuthService.saveAccount`.

---

## 2. Mark Attendance (teacher)

| Layer | Artifact |
|---|---|
| Screen | Mark attendance flow → `AppNavRoutes.markAttendanceRoute` |
| Provider | `MarkAttendanceProvider.saveAttendance` |
| Service | `SaveAttendanceService.saveAttendanceRequest` |
| Endpoint | `SaveAttendance` |
| Request model | `SaveAttendanceRequest` (classSectionId, tokenId, attendanceDate, subjectId, dailyAttendance) |
| Response model | `ResponseMessage` |

Supporting loads (section/students/subjects) use additional services from the same provider (e.g. teacher section / student list) — not expanded here.

---

## 3. Fee Payment

| Layer | Artifact |
|---|---|
| Screen | `FeeChallansScreen` → Pay Now → `ChallanPaymentScreen` (WebView) |
| Provider | `FeeChallanProvider` (list/receipts); payment screen reads `ChallanArgs` |
| Service | `FeeChallanService` |
| Endpoints | `OutstandingChallans`, `ChallansHistory` |
| Request model | `UserDataRequest` (userName, tokenId) |
| Response models | `OutstandingChallanResponse`, `ChallanReceiptResponse` |

Payment itself is **not** an AIMS+ API call: WebView loads:

- New flow URL: `AppConstants.paymentGatewayNewURL` + `{fatherCnic}/{studentId}`
- Legacy: `AppConstants.paymentGatewayURL`

`outstanding_fee_component.dart` currently passes `isNewPaymentFlowEnabled: true` into `ChallanArgs`.

> [!warning] Verification Required
> `FeatureConfigRepository` reads Firestore `newFeatures/newPaymentFlow`, but **no call site** uses the repository; the UI hardcodes the new-flow flag. See [[Firebase/Firestore|Firestore]].

---

## 4. Student Dashboard (`StudentDashboardRepository`)

| Layer | Artifact |
|---|---|
| Screen | `StudentDashboardScreen` |
| Provider | `StudentDashboardProvider` (`StudentDashboardRepository`) |
| Strategy | Offline-first: SharedPreferences bundle via `LocalCacheManager`, TTL 15 min; parallel network fetch |

### Parallel network map (`_fetchFromNetwork`)

| Service | Endpoint | Response model | Populates |
|---|---|---|---|
| `StudentProfileService.stdProfileRequest` | `Profile` | `StudentProfileResponse` | `profile` |
| `AttendancePercentageService.attendancePercentage` | `GetAttendencePercentage` | `AttendancePercentageResponse` | `attendancePercentage` |
| `StudentAttendanceService.studentAttendanceRequest` | `GetMonthlyAttendance` | `StudentAttendanceResponse` | `currentMonthAttendance` |
| `FeeChallanService.outStandingChallanRequest` | `OutstandingChallans` | `OutstandingChallanResponse` | `outstandingChallans` |
| `StudentDiaryService.getDiaryRecords` | `GetDiaryDetails` | `DiaryResponse` | `latestHomework` |
| `NotificationService.notificationRequest` | `Notifications` (group `'3'`) | `NotificationResponse` | `latestCirculars` |
| `StudentAssignmentService.getAssignmentRecords` | `GetClassWorkDetails` | `AssignmentResponse` | `latestAssignments` |
| `StudentSubjectService.getSubjects` | `SearchStudentSubjectList` | `StudentSubjectResponse` | `subjects` |

**Note:** `StudentSubjectService` uses raw `package:http` `http.post` (not `ApiBaseHelper`), still under `AppConstants.apiBaseURL`.

Cache key: `student_dashboard_$studentId`. Bundle type: `student_dashboard_bundle`.

---

## 5. Diary

### Student read

| Layer | Artifact |
|---|---|
| Screen | `studentDiaryRoute` / dashboard homework |
| Provider | `DiaryProvider.loadStudentDiary` |
| Service | `StudentDiaryService.getDiaryRecords` |
| Endpoint | `GetDiaryDetails` |
| Request | `DiaryRequest` (studentId, tokenId) |
| Response | `DiaryResponse` |

### Teacher read / update / delete

| Service method | Endpoint | Models |
|---|---|---|
| `TeacherDiaryService.getDiaryRecords` | `GetDiaryDetailsOfTeacher` | `DiaryRequest` (classTeacherId, tokenId) → `DiaryResponse` |
| `TeacherDiaryService.updateDiary` | `UpdateDiary` | `UpdateDiaryRequest` → `ResponseMessage` |
| `TeacherDiaryService.deleteDiary` | `DeleteDiary` | `DeleteActionRequest` → `ResponseMessage` |

### Teacher add

| Layer | Artifact |
|---|---|
| Screen | `addDiaryRoute` |
| Provider | `DiaryProvider` (+ `AddDiaryService`) |
| Service | `AddDiaryService.addDiary` |
| Endpoint | `AddDiary` |
| Request / response | `AddDiaryRequest` → `ResponseMessage` |

Push tap `route: Diary` navigates to `studentDiaryRoute` (see [[Firebase/Messaging|Messaging]]).

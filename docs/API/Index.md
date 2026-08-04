---
title: API Reference
description: Complete catalog of REST endpoints called by the Cityzens Flutter client.
tags: [cityzens, api, backend]
created: 2026-08-04
updated: 2026-08-04
owner: Cityzens Engineering
status: verified
---

# API Reference

> [!info]
> Backend source is **not** in this repo. Endpoints are inferred from Flutter service/repository call sites. Server contracts: `> [!warning] Verification Required` unless observed in client parsing.

## Configuration

| Environment | Base URL | Active? |
|---|---|---|
| Test | `https://testcityzenapi.csn.edu.pk` | **Yes** (`AppConstants.baseUrl`) |
| Live | `https://cityzenapi.csn.edu.pk` | Available (commented switch) |

API prefix: `{baseUrl}/api/` → `AppConstants.apiBaseURL`

Evidence: `lib/utils/app_constants.dart`

## Common headers

```json
{
  "Content-Type": "application/json; charset=UTF-8",
  "Accept": "application/json"
}
```

> [!warning]
> `ApiBaseHelper.httpPostRequest` builds `Authorization: Bearer <token>` for debug logging but **sends** `AppConstants.appHeaders` only (no Authorization on the wire). See [[Flutter/Networking]].

## HTTP client

All standard calls: `lib/network/api_base_helper.dart` (`package:http`).

| HTTP status | Exception |
|---|---|
| 200 | Success (JSON map) |
| 400 | `BadRequestException` |
| 401 | `InvalidInputException` |
| 403 | `UnAuthorizedException` |
| 404 / 500+ | `FetchDataException` |

Almost all service calls use **POST**. GET/PUT/PATCH/DELETE helpers exist but are unused by services.

## Endpoint catalog

Method is **POST** unless noted.

### Auth & account

| Endpoint | Service / caller | Notes |
|---|---|---|
| `Auth` | `LoginService` | Login |
| `Logout` | `LogoutService` | |
| `Registration` | `RegistrationService` | |
| `ForgetPassword` | `ForgotPasswordService` | |
| `PinCodeVerify` | `VerifyPinCodeService` | Registration pin |
| `CheckPinCode` | `VerifyPinCodeService` | Forgot-password pin |
| `CreatePassword` | `UpdatePasswordService` | Registration |
| `UpdatePassword` | `UpdatePasswordService` | Forgot password |
| `ChangePassword` | `ChangePasswordService` | Logged-in change |
| `RefreshToken` | `FCMTokenRefreshService` | FCM token refresh |

### Profile & children

| Endpoint | Service |
|---|---|
| `Profile` | `StudentProfileService` |
| `TeacherProfile` | `TeacherProfileService` |
| `ChildrenList` | `MultiChildService` |

### Attendance

| Endpoint | Service |
|---|---|
| `GetSubjectsByStudentId` | `AttendanceSubjectsService` |
| `GetMonthlyAttendance` | `StudentAttendanceService`, `StudentALevelAttendanceService` |
| `GetAttendencePercentage` | `AttendancePercentageService` |
| `AttendanceList` | `StudentListService` |
| `SaveAttendance` | `SaveAttendanceService` |
| `GetStudentVerificationReason` | `UnverifiedReasonsService` |
| `StudentVerificationInsert` | `MarkUnverifiedService` |

### Diary / homework

| Endpoint | Service |
|---|---|
| `AddDiary` | `AddDiaryService` |
| `GetDiaryDetails` | `StudentDiaryService` |
| `GetDiaryDetailsOfTeacher` | `TeacherDiaryService` |
| `UpdateDiary` | `TeacherDiaryService` |
| `DeleteDiary` | `TeacherDiaryService` |

### Classwork / assignments

| Endpoint | Service |
|---|---|
| `AddClassAssignment` | `AddAssignmentService` |
| `GetClassWorkDetails` | `StudentAssignmentService` |
| `GetClassWorkTeacher` | `TeacherAssignmentService` |
| `UpdateClassWork` | `TeacherAssignmentService` |
| `DeleteClassWork` | `TeacherAssignmentService` |

### Circulars

| Endpoint | Service |
|---|---|
| `SaveCircularAnnouncement` | `AddCircularService` |
| `GetCircularAnnouncementOfTeacher` | `CircularAnnouncementService` |
| `UpdateAnnouncement` | `CircularAnnouncementService` |
| `DeleteAnnouncement` | `CircularAnnouncementService` |

### Class tests & results

| Endpoint | Service |
|---|---|
| `GetStudentBySubjectId` | `ClassTestResultService`, teacher student list |
| `InsertUpdateTestResult` | `ClassTestResultService` |
| `GetTestResult` | `ClassTestResultService` |
| `PDFResults` | `ResultService` |
| `AllPDFResults` | `ResultService` |
| `DropDown` | `AcademicTermService` |
| `SearchStudentSubjectList` | `StudentSubjectService` (raw `http.post`, not ApiBaseHelper) |

### Timetable & events

| Endpoint | Service |
|---|---|
| `GetClassTimeTable` | `TimeTableService` |
| `SaveUpdateClassTimeTable` | `AddTimetableService` |
| `GetEventCalender` | `StudentEventService`, `TeacherEventService` |
| `InsertUpdateEventCalender` | `AddSchoolEventService` |

### Eye on Your Child

| Endpoint | Service |
|---|---|
| `GetEyeOnYourChildData` | `EyeOnYourChildService` |
| `SaveStudentUpdatesForParent` | `AddEyeOnYourChildService` |
| `GetStudentUpdatesForParent` | `ParentEyeOnYourChildService` |

### Appointments, withdrawal, survey

| Endpoint                | Service                                                         |
| ----------------------- | --------------------------------------------------------------- |
| `GetMeetings`           | `AppointmentService`                                            |
| `GetMeetingConfig`      | `ParentAppointmentService`                                      |
| `SaveMeeting`           | `AddAppointmentService`                                         |
| `GetWithdrawalReasons`  | `WithdrawalRequestService` (also reused by ComplaintQuery load) |
| `SaveWithdrawalRequest` | `AddWithdrawalRequestService`                                   |
| `GetSurveyById`         | `SurveyService`                                                 |
| `UpdateSurveyAnswers`   | `AddSurveyAnswerService`                                        |

### Fees, library, notifications

| Endpoint | Service |
|---|---|
| `OutstandingChallans` | `FeeChallanService` |
| `ChallansHistory` | `FeeChallanService` |
| `Library` | `LibraryService` |
| `Notifications` | `NotificationService` |

### Sections / subjects

| Endpoint | Service / repo |
|---|---|
| `GetSections` | `TeacherSectionService` / `TeacherSectionRepository` |
| `GetSubjects` | `SectionSubjectService` / `SectionSubjectRepository` |

### Online student registration (OSR)

| Endpoint | Service |
|---|---|
| `OSR/AllSessions` | via `OSR/$endpoint` |
| `OSR/AllCities` | via `OSR/$endpoint` |
| `OSR/Countries` | via `OSR/$endpoint` |
| `OSR/CampusByCity` | via `OSR/$endpoint` |
| `OSR/ClassByCampus` | via `OSR/$endpoint` |
| `OSR/AddRegistration` | `OSRegistrationService` |

> [!warning] Verification Required
> Exact OSR sub-endpoint names passed as `$endpoint` — confirm against `OSRegistrationProvider` call sites when changing OSR.

### Launch promotions

| Endpoint | Caller |
|---|---|
| `GetAllLaunchPromotions` | `PromotionRepository` |
| `CreateLaunchPromotion` | `PromotionRepository` (JSON or multipart) |
| `UpdateLaunchPromotion` | `PromotionRepository` (JSON or multipart) |
| `DeleteLaunchPromotion` | `PromotionRepository` |

## Static file URLs (on `baseUrl`, not `/api/`)

| Pattern | Usage |
|---|---|
| `{baseUrl}/MobileAppAttachments/{file}` | Assignments |
| `{baseUrl}/MobileAppAttachments/DailyDiary/{file}` | Diary |
| `{baseUrl}/MobileCircularAnnouncement/{file}` | Circulars |

## External (non-ERP)

| URL | Usage |
|---|---|
| `https://billing.thecityschool.edu.pk/challan` | Legacy payment WebView |
| `https://billing.thecityschool.edu.pk/directpayment/{cnic}/{studentId}` | New payment WebView |

## Firestore (not REST)

| Collection / doc | Caller |
|---|---|
| `newFeatures` / `newPaymentFlow` | `FeatureConfigRepository` |

> [!note]
> Pay navigation currently hardcodes `isNewPaymentFlowEnabled: true` in `outstanding_fee_component.dart`; repository exists but is not wired on that path.

## Service pattern

```dart
class SomeService {
  static Future<SomeResponse> someRequest({required String param}) async {
    final response = await ApiBaseHelper.httpPostRequest(
      'EndpointName',
      body: {'Param': param},
    );
    return SomeResponse.fromJson(response);
  }
}
```

## Related

- [[Backend/Index|Backend]] · [[Backend/API Client|API Client]] · [[Backend/Screen API Maps|Screen API Maps]]
- [[Architecture/Index|Architecture]] · [[Home]]

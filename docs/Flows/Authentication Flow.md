# Authentication Flow

## Overview

The app supports three user roles with distinct login credentials:

| Role | Username | Format |
|---|---|---|
| Student | Roll Number | `230935` |
| Teacher | Employee Number | `10045678` |
| Parent | Father CNIC | `42101-1234567-1` |

---

## Login Flow

```mermaid
graph TD
    A["App Launch"] --> B["SplashScreenUI"]
    B --> C["AuthWrapper"]
    C --> D{"Token in<br/>SharedPreferences?"}
    D -->|No| E["LoginScreen"]
    D -->|Yes| F{"userType?"}
    
    E --> G["UserTypeTabSelector<br/>Student / Teacher / Parent"]
    G --> H["Enter credentials"]
    H --> I["LoginProvider.login()"]
    I --> J["LoginService.loginRequest()"]
    J -->|Success| K["Store LoginResponse<br/>in SharedPreferences"]
    K --> L["pushReplacementTo(AuthWrapper)"]
    L --> F
    
    J -->|Server Error| M["SnackBar: Server Error"]
    J -->|Auth Failed| N["SnackBar: error message"]
    
    F -->|Student| O["StudentDashboardScreen"]
    F -->|Teacher| P["TeacherDashboardScreen"]
    F -->|Parent| Q["StudentDashboardScreen<br/>(with child selector)"]
```

### Login Response Model

```dart
class LoginResponse {
  String? tokenId;       // Session token
  String? name;          // Display name
  int? id;               // User ID
  UserInfo? info;        // Nested: Name, StudentId, ClassName, CenterName, RegionName, FatherEmail, Grade_Id
  String? userType;      // 'Student' | 'Teacher' | 'Parent'
  String? userName;      // Login username
  int? gradeId;          // Grade ID (for A-Level detection: 19/20)
  bool? isSuccessful;
  String? message;
}
```

### Key Implementation Details

- `LoginProvider` uses `MaskedTextController` for input formatting
  - Student/Teacher: `00000000` (8-digit numeric)
  - Parent: `00000-0000000-0` (CNIC format)
- `UserTypeTabSelector` is the inline role picker (no bottom sheet)
- On success: `LoginResponse` serialized as JSON string → `SharedPreferences` key `userData`
- After save: `pushReplacementTo(AuthWrapper)` — AuthWrapper reads the stored data and routes

---

## Registration Flow

New users must register before they can log in. Registration is available for **Students** and **Parents** only (first 2 user types).

```mermaid
graph TD
    A["LoginScreen"] --> B["Tap 'Register Now'"]
    B --> C["IntroductionScreenPage<br/>(app walkthrough)"]
    C --> D["RegistrationScreen"]
    
    D --> E["Select role: Student / Parent"]
    E --> F["Enter username<br/>(Roll Number or CNIC)"]
    F --> G["Enter mobile number"]
    G --> H["Tap 'Register'"]
    H --> I["RegistrationProvider.userRegistration()"]
    I --> J["RegistrationService.userRegRequest()"]
    
    J -->|Success| K["Store ResponseMessage"]
    K --> L["Navigate to RegPinCodeScreen"]
    L --> M["Success dialog shows<br/>OTP sent message"]
    M --> N["Enter PIN code (OTP)"]
    N --> O["RegistrationProvider.verifyPinCode()"]
    O --> P["VerifyPinCodeService.verifyPinCodeRequest()<br/>(isRegPin: true)"]
    
    P -->|Success| Q["Navigate to CreatePasswordScreen"]
    Q --> R["Enter new password<br/>(min 8 characters)"]
    R --> S["Enter confirm password"]
    S --> T["RegistrationProvider.createPassword()"]
    T --> U["UpdatePasswordService.updatePasswordRequest()<br/>(isRegPass: true)"]
    
    U -->|Success| V["removeAllRoutes()"]
    V --> W["SnackBar: Password created"]
    W --> X["Back to LoginScreen"]
    
    J -->|Failure| Y["SnackBar: error message"]
    P -->|Failure| Z["SnackBar: error message"]
    U -->|Failure| AA["SnackBar: error message"]
```

### Registration Steps

| Step | Screen | Provider Method | Service | Validation |
|---|---|---|---|---|
| 1. Enter info | `RegistrationScreen` | `userRegistration()` | `RegistrationService.userRegRequest()` | Username + mobile number |
| 2. Verify OTP | `RegPinCodeScreen` | `verifyPinCode()` | `VerifyPinCodeService.verifyPinCodeRequest(isRegPin: true)` | PIN code |
| 3. Set password | `CreatePasswordScreen` | `createPassword()` | `UpdatePasswordService.updatePasswordRequest(isRegPass: true)` | Password ≥ 8 chars + match |

### Important Notes

- Registration only supports **Student** and **Parent** roles (`userTypeList.take(2)`)
- Teachers are pre-registered via the admin system
- The `isRegPin: true` and `isRegPass: true` flags differentiate registration from forgot-password flows on the backend
- On successful password creation, all routes are cleared and user returns to a clean login state
- The `RegistrationProvider` reads `LoginProvider.userType` to pre-select the role tab

---

## Forgot Password Flow

Existing users who forget their password follow a similar OTP-verified flow.

```mermaid
graph TD
    A["LoginScreen"] --> B["Tap 'Forgot Password?'"]
    B --> C["ForgotPasswordScreen"]
    
    C --> D["Select role: Student / Parent"]
    D --> E["Enter username<br/>(Roll Number or CNIC)"]
    E --> F["Enter mobile number"]
    F --> G["Tap 'Submit'"]
    G --> H["ForgotPasswordProvider.forgotPassword()"]
    H --> I["ForgotPasswordService.forgotPasswordRequest()"]
    
    I -->|Success| J["Store ResponseMessage"]
    J --> K["Navigate to ForgotPinCodeScreen"]
    K --> L["Success dialog: OTP sent"]
    L --> M["Enter PIN code (OTP)"]
    M --> N["ForgotPasswordProvider.verifyPinCode()"]
    N --> O["VerifyPinCodeService.verifyPinCodeRequest()"]
    
    O -->|Success| P["Navigate to UpdatePasswordScreen"]
    P --> Q["Enter new password"]
    Q --> R["Enter confirm password"]
    R --> S["ForgotPasswordProvider.updatePassword()"]
    S --> T["UpdatePasswordService.updatePasswordRequest()"]
    
    T -->|Success| U["removeAllRoutes()"]
    U --> V["SnackBar: Password updated"]
    V --> W["Back to LoginScreen"]
```

### Forgot Password Steps

| Step | Screen | Provider Method | Service |
|---|---|---|---|
| 1. Request reset | `ForgotPasswordScreen` | `forgotPassword()` | `ForgotPasswordService.forgotPasswordRequest()` |
| 2. Verify OTP | `ForgotPinCodeScreen` | `verifyPinCode()` | `VerifyPinCodeService.verifyPinCodeRequest()` |
| 3. New password | `UpdatePasswordScreen` | `updatePassword()` | `UpdatePasswordService.updatePasswordRequest()` |

### Key Differences from Registration

| Aspect | Registration | Forgot Password |
|---|---|---|
| Roles available | Student, Parent only | Student, Parent only |
| OTP verify flag | `isRegPin: true` | `isRegPin: false` (default) |
| Password set flag | `isRegPass: true` | `isRegPass: false` (default) |
| Entry point | "Register Now" button | "Forgot Password?" link |
| Intro screen | Yes (app walkthrough) | No |

---

## Change Password (Post-Login)

Available from the Navigation Drawer for all logged-in users.

```mermaid
graph TD
    A["Navigation Drawer"] --> B["ChangePasswordScreen"]
    B --> C["Enter current password"]
    C --> D["Enter new password"]
    D --> E["Confirm new password"]
    E --> F["Submit"]
    F --> G["ChangePasswordService"]
    G -->|Success| H["SnackBar: Password changed"]
```

---

## Session Management

| Action | Implementation |
|---|---|
| **Store session** | `LoginResponse` → JSON → `SharedPreferences('userData')` |
| **Read session** | `LocalDataProvider.loadStoredData()` → parse JSON → `LoginResponse` |
| **Logout** | `LogoutService.logoutRequest(tokenId)` → clear SharedPreferences → push AuthWrapper |
| **Auto-logout** | API returns "Invalid Access Key" → global interceptor triggers logout |
| **Upgrade guard** | `upgrader` package checks `minAppVersion` on AuthWrapper |
| **Teacher cache** | Teacher profile also cached under key `teacherProfileData` |

---

## A-Level Detection

Grade IDs `19` and `20` indicate A-Level students. This affects:
- Student attendance routing → subject-wise (chips) instead of direct calendar
- Teacher attendance → requires subject selection before marking
- Time lock bypass → A-Level classes are exempt from the 10 AM attendance cutoff

---

## Key Files

| File | Purpose |
|---|---|
| `lib/screens/LoginScreen/login_screen.dart` | Login UI with inline role tabs |
| `lib/provider/Login/login_provider.dart` | Login state + API call + role switching |
| `lib/provider/Registration/registration_provider.dart` | Registration 3-step flow |
| `lib/provider/ForgotPassword/forgot_password_provider.dart` | Forgot password 3-step flow |
| `lib/model/Login/login_response.dart` | `LoginResponse` + `UserInfo` model |
| `lib/screens/AuthWrapper/auth_wrapper.dart` | Post-login routing by role |
| `lib/provider/LocalData/local_data_provider.dart` | Session persistence + logout |
| `lib/screens/Registration/RegistrationScreen/` | Step 1: Enter username + mobile |
| `lib/screens/Registration/RegPinCodeScreen/` | Step 2: OTP verification |
| `lib/screens/Registration/CreatePasswordScreen/` | Step 3: Set password |
| `lib/screens/ForgotPassword/ForgotPasswordScreen/` | Step 1: Request reset |
| `lib/screens/ForgotPassword/ForgotPinCodeScreen/` | Step 2: OTP verification |
| `lib/screens/ForgotPassword/UpdatePasswordScreen/` | Step 3: Set new password |
| `lib/screens/Introduction/introduction_screen.dart` | App walkthrough before registration |

## Related Pages

- [[Teacher Flow]]
- [[Student Flow]]
- [[Parent Flow]]

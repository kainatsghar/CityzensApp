# CITYZENS — Release Notes / Full Changelog

**Version:** 2.0.0+89 (from production **1.13.2+88**)

**Branches:** `new_temp_v_1_13_3` ← `version-1.13.2+88`

**Document date:** 10-08-2026

This document lists the full product-facing changes between the live production branch and the latest release candidate. Lead change: **full UI/UX redesign across nearly all screens**, plus new Academic Hub, PDF Results, biometric login, and API-based promotions.

Companion UAT form: [Cityzens_App_V2.0.0_UAT_Sign-Off_Sheet.docx](Cityzens_App_V2.0.0_UAT_Sign-Off_Sheet.docx)

## 1. App-wide UI/UX redesign (primary callout)

- This release is a major visual and interaction overhaul. Nearly all screens have been migrated to the new design system (shared Custom Card, updated theme/colors/typography, refreshed headers/profile cards, shimmer loading states, and tab/chip selectors replacing many dropdowns).
- Shared design system: application-wide theme consistency; Custom Card applied as the single card pattern; UI styling tokens updated; color opacity APIs migrated to withValues; Nexa fonts removed.
- Auth / onboarding: Login role selection converted from dropdown to tab selector (Student / Teacher / Parent); UserTypeTabSelector modernized; Change Password screen redesigned with particle background and responsive sliver layout; registration / PIN / create-password flows restyled.
- Splash / launch: Splash UI refreshed; Launch Promotions presentation updated (API-backed).
- Student dashboard & profile: Full student dashboard rebuild; redesigned student info header; enhanced Student Profile Card (roll number, attendance details); updated dashboard cards/widgets with formatted dates and improved layout; financial status UI enhanced.
- Parent experience: Separate Parent Dashboard removed; parents use the Student Dashboard with child selector; empty-state UI when no active children are linked; Eye on Your Child component logic/UI refreshed.
- Teacher dashboard & profile: Teacher Dashboard rebuilt with scroll-based app bar; Teacher Profile Card with richer info; gender-based avatars (including female avatar); formatted dates and compact layouts; auto section/subject selection; feedback button design refreshed.
- Academic Hub (Student & Teacher): New unified hub UI combining Homework, Classwork, and Circulars with shared academic card component.
- Academic Results: New PDF results list/viewer/download screens; teacher class-result modern screens restyled; Academic Results hub tile visibility gated by grade.
- Attendance / timetable: Attendance loading shimmer; calendar relocated before statistics on student attendance; A-Level subject selection UI improved; teacher attendance/timetable section pages use tab selection instead of dropdowns.
- Fees / challan: Updated Challan view and fee challan presentation; fee components reorganized with student info header.
- Library & notifications: Library screen and notification/message/challan notification screens restyled under the new theme.
- Teacher academic input screens: Add/Edit Diary, Assignment, and Circular screens rebuilt with updated UI components; date pickers constrained to selected date.
- Decorative/motion: ParticleBackground performance optimized (compositor-driven); particle density adjusted on selected screens.
- Other module screens touched by theme migration include surveys, school events, appointments, OS registration, IEP, and related supporting flows.

## 2. New features

- Academic Hub for students and teachers — Homework, Classwork, and Circulars in one tabbed experience.
- Academic Results PDFs — list term/archive PDFs, open in-app viewer, download with local caching.
- Biometric login — Face ID / fingerprint (device biometrics) with securely stored saved accounts for faster re-login.
- My Subjects — student subject list with assigned teachers integrated on the dashboard.
- Teacher edit/delete for Homework (Diary), Classwork (Assignment), and Circulars.
- Student profile enhancements — roll number, attendance details, richer profile card content.
- Gender-based teacher avatars.
- App analytics — login and feature engagement tracking on student flows (Firebase Analytics via AppAnalyticsService).
- Parent empty-state handling when no linked/active children are available, with refresh path.
- Max Marks field updates on class test / marks entry flows.
- All PDF Results retrieval/display screen on student dashboard.

## 3. Bug fixes

- Promotion / launch promo link handling corrected so taps open the intended URL reliably.
- Fee/profile fallback when student profile data is incomplete (avoids broken fee UI).
- Teacher date pickers restricted to the currently selected date on diary/assignment/circular entry.
- Subject selection disabled during edit of teacher records (prevents wrong section/subject updates); edit resolution improved via section IDs.
- Comprehensive logout/provider state cleanup so prior user data does not linger across sessions/accounts.
- FeeChallanProvider synced on child switch.
- “Late” removed from student dashboard attendance service object usage (attendance display cleanup).
- API authorization header handling improved for authenticated requests.

## 4. Performance / caching

- Teacher cache: profile, sections, and subjects loaded once at dashboard init and reused across screens (refreshed on app restart).
- Per-student profile caching for faster child/dashboard loads.
- Results PDF disk cache to avoid re-downloading the same PDFs.
- Student dashboard force-refresh / class filtering for results data freshness.
- Dashboard initialization moved toward repository pattern; standardized clearFormState cleanup.
- Particle background performance optimization.

## 5. Security / auth

- Biometric authentication service (local_auth).
- Secure credential storage (flutter_secure_storage) for saved accounts.
- Session/provider wipe on logout across major modules.
- Improved API authorization header logic.
- Password updates can sync into saved biometric accounts where applicable.

## 6. API / backend integration

- Launch Promotions migrated from Firebase/Firestore to ERP API (GetAllLaunchPromotions and related create/update/delete); launch promo still shown between splash and login.
- Results APIs: PDFResults / AllPDFResults plus PDF download/open pipeline.
- Student Subjects API wired into dashboard.
- Teacher CRUD APIs for update/delete of diary, assignment, and circular/announcement records.
- Centralized URL launching logic; Android manifest queries updated for improved link handling.
- Circular file attachment URL source updated.

## 7. Hidden / disabled / grade-gated behavior

- Academic Results hub hidden for Grades 2, 3, and 4 (Grades 5–6 currently re-enabled for Results).
- Complaint/Query UI remains hidden/disabled in the student hub (code retained; not user-facing for this release).
- Dashboard hub tiles still present but inactive (onTap null): Events, Survey, Appointment, Withdrawal, Complaints.
- Promotion management screens available in debug builds only (not for production end users).

## 8. Platform / dependency upgrades

- App version bumped from 1.13.2+88 to 2.0.0+89.
- Gradle upgraded to 8.14; iOS CocoaPods re-linked.
- Added: local_auth, flutter_secure_storage, connectivity_plus, path_provider, open_filex, flutter_inappwebview.
- Firebase packages upgraded (core, messaging, crashlytics, remote_config, analytics, cloud_firestore).
- Other dependency bumps: image_picker/cropper, device_info_plus, package_info_plus, flutter_local_notifications, file_picker, upgrader, animate_do, lottie, etc.
- open_file replaced with open_filex; grouped_list / introduction_screen removed from pubspec in this line.

## 9. Suggested UAT focus

- Login: role tabs + biometric save / login / remove account for Student, Teacher, and Parent.
- Full visual regression of Student Dashboard, Teacher Dashboard, profiles, Academic Hub, attendance, challan, and change password.
- Academic Hub tabs + teacher edit/delete for diary, assignment, circular.
- Academic Results PDF list / open / download; confirm Grades 2–4 do not see Results hub.
- Parent with no linked children → empty state + refresh.
- Launch promotion display and external link open.
- Teacher mark attendance / timetable using cached sections & subjects; auto-selection behavior.
- Fee challan after child switch.
- Logout then login as another user (no data bleed).

## 10. Branch / version reference

- Production (live): branch version-1.13.2+88 — app version 1.13.2+88.
- Latest (this release): branch new_temp_v_1_13_3 — app version 2.0.0+89.
- Approx. 49 commits between branches; large application-side UI and feature delta.
- UAT Sign-Off reference: DEP-Cityzens-v2.0.0 — Cityzens_App_V2.0.0_UAT_Sign-Off_Sheet.docx.

## 11. Internal / non-user-facing (optional awareness)

- Technical documentation vault initialized under docs/.
- Postman API collection and Live/Test environment configs added under postman/.

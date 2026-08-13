# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

-

### Changed

-

### Fixed

-

### Security

-

## [2.0.0] - 2026-08-10

Compared to production **1.13.2+88** (`version-1.13.2+88`). Full detailed notes: [docs/Deployment/Cityzens_v2.0.0_Release_Notes.md](docs/Deployment/Cityzens_v2.0.0_Release_Notes.md) · UAT form: [docs/Deployment/Cityzens_App_V2.0.0_UAT_Sign-Off_Sheet.docx](docs/Deployment/Cityzens_App_V2.0.0_UAT_Sign-Off_Sheet.docx).

### Changed — App-wide UI/UX redesign

- **Major visual overhaul across nearly all screens** (login, dashboards, profiles, academic modules, fees/challan, attendance, settings, and supporting flows).
- Shared design system: Custom Card, theme/colors/typography tokens, shimmer loading, tab/chip selectors replacing many dropdowns.
- Login role selection via tabs (Student / Teacher / Parent); Change Password redesigned.
- Student dashboard & profile card rebuilt (roll number, attendance details, financial status).
- Parent Dashboard removed; parents use Student Dashboard with child selector and empty-state when no linked children.
- Teacher dashboard rebuilt (scroll app bar, profile card, gender-based avatars, auto section/subject selection).
- Attendance/timetable UX updated (shimmer, calendar placement, tab selectors).
- Challan / fee presentation updated.
- Library, notifications, surveys, events, and related module screens restyled under the new theme.

### Added

- Academic Hub (Student & Teacher) — Homework, Classwork, Circulars in one hub.
- Academic Results PDFs — list, in-app view, download, and local cache.
- Biometric login with secure credential storage (saved accounts).
- My Subjects on student dashboard.
- Teacher edit/delete for diary, assignment, and circulars.
- App analytics for login and student feature engagement.
- Parent empty-state when no active/linked children.
- All PDF Results screen; Max Marks field updates.
- UAT Sign-Off sheet and full release notes under `docs/Deployment/`.
- Documentation vault under `docs/`; Postman collection/environments under `postman/`.

### Fixed

- Promotion / launch promo link opening.
- Fee UI fallback when student profile data is incomplete.
- Teacher date pickers limited to selected date; subject locked during edits; section-ID edit resolution.
- Logout clears provider state across modules (no cross-account data bleed).
- Fee challan sync on child switch.
- Student dashboard attendance “Late” cleanup.
- API authorization header handling.

### Performance

- Teacher profile/sections/subjects cached at dashboard init.
- Per-student profile caching.
- Results PDF disk cache.
- Student dashboard force-refresh / class filtering for results.
- Particle background performance improvements.

### Security

- `local_auth` biometric authentication.
- `flutter_secure_storage` for saved credentials.
- Session/provider wipe on logout.
- Improved API authorization headers.

### API / platform

- Launch Promotions migrated from Firebase to ERP API.
- Results PDF APIs; Student Subjects API; teacher diary/assignment/circular CRUD.
- Centralized URL launching; Android manifest query updates.
- Version **2.0.0+89**; Gradle 8.14; Firebase and dependency upgrades (`local_auth`, `flutter_secure_storage`, `connectivity_plus`, `open_filex`, `flutter_inappwebview`, etc.).

### Hidden / gated

- Academic Results hub hidden for Grades 2–4.
- Complaint/Query UI remains hidden.
- Events / Survey / Appointment / Withdrawal / Complaints hub tiles inactive.
- Promotion management screens debug-only.

> Note: Intermediate 1.x release notes were not recorded in this file historically. Treat `pubspec.yaml` / store listings as the version source of truth for builds prior to this changelog seed.

## [0.1.0] - 2026-02-27

### Added

- Initial release of CityzensApp (changelog stub retained for history).

---
title: Flutter Custom Widgets
description: Inventory of lib/custom_widgets folders used as the app design-system kit.
tags: [cityzens, flutter, widgets, design-system]
created: 2026-08-04
updated: 2026-08-04
owner: Cityzens Engineering
status: verified
---

# Widgets

> Back to [[Home]] · [[Flutter/Index|Flutter]] · [[Design System/Index|Design System]] · [[Diagrams/Master Architecture|Master Architecture]]

Reusable UI lives under `lib/custom_widgets/`. Each folder is a self-contained widget package used across screens/components.

## Folder inventory (39)

| Folder | Role (from naming / primary file) |
|---|---|
| `CustomAppBar` | App bars |
| `CustomAppButton` | Primary buttons (+ dark-background back button) |
| `CustomBottomSheets` | Bottom sheets / filters / image picker sheet |
| `CustomCard` | Card container |
| `CustomCoverImage` | Cover imagery |
| `CustomDashboardButton` | Dashboard action tiles |
| `CustomDialogBoxes` | Loading / success / delete-confirm dialogs |
| `CustomDivider` | Dividers |
| `CustomDropdown` | Dropdowns |
| `CustomExpansionTile` | Expansion tiles |
| `CustomListTile` | List tiles |
| `CustomLoader` | Loaders / loading widget |
| `CustomLogoCover` | Logo cover |
| `CustomNoteCard` | Note cards |
| `CustomPercentageBar` | Percentage bars |
| `CustomProfileItem` | Profile rows |
| `CustomSnackbar` | Snackbars |
| `CustomStudentInfo` | Student info header (uses Axiforma) |
| `CustomSubjectGrade` | Subject grade display |
| `CustomTabBar` | Tab bars |
| `CustomTestResultFormField` | Class-test result fields |
| `CustomTextFormField` | Text fields (incl. v2, centered error variant) |
| `CustomTimeTableFormField` | Timetable fields |
| `CustomTitleValue` | Title/value pairs |
| `CustomToast` | Toasts |
| `CustomToggleButton` | Toggle |
| `CustomUserImage` | User avatar (local path / assets) |
| `GlassmorphicCard` | Glassmorphic card |
| `LogoWidget` | App logo |
| `ParticleBackground` | Animated particle background (splash) |
| `ProgressButton` | Progress button + painter |
| `RoyalParticlePainter` | Particle painter |
| `ShimmerEffect` | Dashboard / attendance shimmers |
| `ShowCustomMessage` | Custom messages / survey / image message |
| `ShowError` | Error body (also used by route error page) |
| `TabSelector` | Tab selector |
| `TeacherProfileCard` | Teacher profile card |
| `UnifiedAcademicCard` | Academic hub card |
| `UserTypeTabSelector` | Student / Teacher / Parent tab selector |

## Notes

- Screens compose these widgets; feature-specific UI also lives under `lib/components/`.
- Route error page uses `CustomAppBar` + `ShowError` (see [[Flutter/Routing|Routing]]).

---
title: Design System
description: Code-verified AppColors tokens and custom widget inventory for Cityzens.
tags: [cityzens, design-system, colors, widgets]
created: 2026-08-04
updated: 2026-08-04
owner: Cityzens Engineering
status: verified
---

# Design System

> Back to [[Home]] · Source: `lib/utils/app_colors.dart`

Tokens below are **code-verified** against `AppColors`. Invented names from older docs (`primaryDark`, `goldenYellow`, `background`, `success` as `#10B981`, etc.) that are **not** in the file were removed.

## Color Palette

### Brand / Primary

| Token | Hex | Usage |
|---|---|---|
| `primaryBlue` | `#485CC7` | Primary brand, headers, active states |
| `primaryDarkBlue` | `#303F9F` | Dark variant, gradients |
| `primaryColor` | `#617FFF` | Alternate primary accent |
| `primaryLightBlue` | `#E8ECFF` | Light tint backgrounds |
| `purple` | `#4F5FEB` | Accent purple |
| `indigoDeep` | `#1A237E` | Deep indigo |
| `navyBlue` | `#003875` | Navy |
| `indigo` | `#3F51B5` | Material indigo |
| `indigoLight` | `#5C6BC0` | Light indigo |

### Secondary / Accent

| Token | Hex | Usage |
|---|---|---|
| `secondaryColor` | `#F3CD50` | Secondary accent, badges, highlights |
| `paleYellow` | `#FFF6D2` | Soft accent backgrounds |
| `warningOrange` | `#FBA95D` | Warning orange |
| `amber` | `#FFC107` | Amber |
| `orange` / `orangeAccent` / `deepOrange` | `#FF9800` / `#FFAB40` / `#FF7043` | Orange scale |

### Tertiary

| Token | Hex |
|---|---|
| `tertiaryLight` | `#D9B38C` |
| `tertiaryDark` | `#7C4F35` |

### Background / Surface

| Token | Hex |
|---|---|
| `white` | `#FFFFFF` |
| `ultraLightGrey` | `#F7F7F7` |
| `slate50` | `#F8FAFC` |
| `slate100` | `#F1F5F9` |
| `softBlueGrey` | `#F6F8FB` |
| `softBlueGreyAlt` | `#F8FAFD` |
| `nearWhite` | `#F0F0F0` |
| `darkSurface` | `#1B1E28` |

### Neutrals / Greys

| Token | Hex |
|---|---|
| `black` | `#000000` |
| `softGreyText` | `#6F6F6F` |
| `charcoal` | `#535353` |
| `borderGrey` | `#E5E5E5` |
| `grey` | `#EBEAEA` |
| `lightGrey` | `#C9C9C9` |
| `grey50` … `grey800` | Material grey scale (`#FAFAFA` … `#424242`) |
| `blueGrey` / `blueGreyLight` | `#607D8B` / `#ECEFF1` |
| `neutral50` / `100` / `300` / `500` / `700` / `900` | `#F9FAFB` … `#111827` |
| `border` | `#EDE9E0` |

### Text

| Token | Hex |
|---|---|
| `textPrimary` | `#1F2937` |
| `textSecondary` | `#4B5563` |

### Status / Semantic

| Token | Hex | Usage |
|---|---|---|
| `errorRed` | `#FF2B5F` | Brand error red |
| `error` | `#EF4444` | Semantic error |
| `errorLight` | `#FEE2E2` | Error background |
| `materialRed` / `redAccent` / `red300`–`red800` | Material red scale | |
| `lightRed` / `softPink` | `#E04D83` / `#F5687B` | Soft red/pink |
| `successGreen` | `#07CDA5` | Success / present |
| `materialGreen` / `green300` / `green600` / `greenAccent` | Green scale | |
| `teal` | `#26A69A` | Teal |
| `materialBlue` / `lightBlue` | `#2196F3` / `#42A5F5` | Info blues |
| `softLavender` | `#E3A5EC` | Accent |

Opacity helpers (`white05`…`white90`, `black12`…`black54`) and `navyOverlay` (`#ED002D62`) also live in `AppColors`.

### Gradients (usage patterns)

| Pattern | Colors |
|---|---|
| Brand blue gradient | `primaryBlue` → `primaryDarkBlue` |
| Dashboard / profile overlays | Often include `navyOverlay` |

Exact gradient stops vary by widget; prefer composing from tokens above.

## Typography

| Font | Weights | Usage |
|---|---|---|
| **Axiforma** | Light (400), Regular (500), Bold (700) | Primary UI font |
| **Nunito** | Light (400), Regular (500), Bold (700) | Secondary font |

## Custom Widget Library

### Layout Widgets

| Widget | Path | Purpose |
|---|---|---|
| `CustomAppBar` | `custom_widgets/CustomAppBar/` | Unified app bar across all screens |
| `CustomCard` | `custom_widgets/CustomCard/` | Standard card container |
| `GlassmorphicCard` | `custom_widgets/GlassmorphicCard/` | Premium frosted-glass card |
| `CustomDivider` | `custom_widgets/CustomDivider/` | Themed divider |

### Input Widgets

| Widget | Path | Purpose |
|---|---|---|
| `CustomTextFormField` | `custom_widgets/CustomTextFormField/` | Themed text input with icons |
| `CustomDropdown` | `custom_widgets/CustomDropdown/` | Styled dropdown |
| `CustomToggleButton` | `custom_widgets/CustomToggleButton/` | Toggle switch |
| `UserTypeTabSelector` | `custom_widgets/UserTypeTabSelector/` | Role selector tabs on login |

### Action Widgets

| Widget | Path | Purpose |
|---|---|---|
| `CustomAppButton` | `custom_widgets/CustomAppButton/` | Primary action button |
| `ProgressButton` | `custom_widgets/ProgressButton/` | Button with loading state |
| `CustomDashboardButton` | `custom_widgets/CustomDashboardButton/` | Dashboard grid tile |

### Feedback Widgets

| Widget | Path | Purpose |
|---|---|---|
| `CustomLoader` | `custom_widgets/CustomLoader/` | Centered loading spinner |
| `DashboardShimmer` | `custom_widgets/ShimmerEffect/` | Dashboard skeleton loader |
| `AttendanceShimmer` | `custom_widgets/ShimmerEffect/` | Attendance skeleton loader |
| `CustomSnackbar` | `custom_widgets/CustomSnackbar/` | Themed notification bar |
| `CustomDialogBoxes` | `custom_widgets/CustomDialogBoxes/` | Loading dialog overlay |
| `ShowError` | `custom_widgets/ShowError/` | Error state display |
| `CustomToast` | `custom_widgets/CustomToast/` | Toast messages |

### Display Widgets

| Widget | Path | Purpose |
|---|---|---|
| `CustomUserImage` | `custom_widgets/CustomUserImage/` | User avatar with caching |
| `CustomLogoCover` | `custom_widgets/CustomLogoCover/` | School logo display |
| `CustomProfileItem` | `custom_widgets/CustomProfileItem/` | Profile field row |
| `CustomTitleValue` | `custom_widgets/CustomTitleValue/` | Label-value pair |
| `CustomPercentageBar` | `custom_widgets/CustomPercentageBar/` | Horizontal progress bar |
| `CustomSubjectGrade` | `custom_widgets/CustomSubjectGrade/` | Subject grade badge |
| `CustomNoteCard` | `custom_widgets/CustomNoteCard/` | Info card |
| `TeacherProfileCard` | `custom_widgets/TeacherProfileCard/` | Teacher dashboard profile strip |
| `ParticleBackground` | `custom_widgets/ParticleBackground/` | Animated particle effect |
| `RoyalParticlePainter` | `custom_widgets/RoyalParticlePainter/` | Custom painter for particles |
| `LogoWidget` | `custom_widgets/LogoWidget/` | Logo display utility |

### Overlay Widgets

| Widget | Path | Purpose |
|---|---|---|
| `CustomBottomSheets` | `custom_widgets/CustomBottomSheets/` | Filter/selection bottom sheets |
| `CustomExpansionTile` | `custom_widgets/CustomExpansionTile/` | Expandable section |
| `TabSelector` | `custom_widgets/TabSelector/` | Custom tab bar |

## Animation Patterns

The app uses `animate_do` extensively:

| Animation | Typical Usage |
|---|---|
| `FadeIn` | Subtle element reveals |
| `FadeInDown` | Statistics cards, subject chips |
| `FadeInUp` | Calendar, action buttons |
| `AnimatedContainer` | Subject chip selection transitions (200ms) |

## Related Pages

- [[Flutter/Theme|Theme]]
- [[Diagrams/Theme Flow|Theme Flow]]
- [[Architecture/Index|Architecture Overview]]
- [[Features/Index|Features]]

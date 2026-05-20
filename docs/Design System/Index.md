# Design System

## Color Palette

Defined in `lib/utils/app_colors.dart`.

### Brand Core

| Token | Hex | Preview | Usage |
|---|---|---|---|
| `primaryBlue` | `#485CC7` | 🟦 | Headers, active states, primary actions |
| `primaryDarkBlue` | `#303F9F` | 🟦 | Dark variant, gradient end |
| `primaryDark` | `#1E2A6B` | 🟦 | Deep backgrounds |
| `primaryLightBlue` | `#E8ECFF` | 🟦 | Light tint backgrounds |
| `goldenYellow` | `#F3CD50` | 🟨 | Secondary accent, badges, CTAs |
| `paleYellow` | `#FFF6D2` | 🟨 | Soft accent backgrounds |

### Neutral Palette

| Token | Hex | Usage |
|---|---|---|
| `background` | `#F8F7F4` | Warm off-white page background |
| `surface` / `card` | `#FFFFFF` | Card surfaces |
| `border` | `#EDE9E0` | Card borders |
| `neutral900` | `#111827` | Darkest text |
| `neutral700` | `#374151` | Body text |
| `neutral500` | `#6B7280` | Secondary text |
| `neutral300` | `#D1D5DB` | Disabled states |
| `neutral100` | `#F3F4F6` | Subtle backgrounds |

### Status Colors

| Token | Hex | Usage |
|---|---|---|
| `success` | `#10B981` | Present, positive actions |
| `successLight` | `#D1FAE5` | Success backgrounds |
| `error` | `#EF4444` | Absent, errors |
| `errorLight` | `#FEE2E2` | Error backgrounds |
| `warning` | `#F59E0B` | Leave, warnings |
| `warningLight` | `#FEF3C7` | Warning backgrounds |

### Gradients

| Name | Colors |
|---|---|
| Blue Gradient | `#303F9F → #1E2A6B` |
| Gold Gradient | `#F3CD50 → #DBB13F` |
| Dashboard Card | `primaryBlue → Color(0xED002D62)` |

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

- [[Architecture/Index|Architecture Overview]]
- [[Features/Index|Features]]

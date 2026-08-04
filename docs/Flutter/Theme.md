---
title: Flutter Theme
description: Light-only AppThemes.lightTheme, AppColors palette, Axiforma and Nunito fonts.
tags: [cityzens, flutter, theme, colors, fonts]
created: 2026-08-04
updated: 2026-08-04
owner: Cityzens Engineering
status: verified
---

# Theme

> Back to [[Home]] · [[Flutter/Index|Flutter]] · [[Design System/Index|Design System]] · [[Diagrams/Master Architecture|Master Architecture]]

Sources: `lib/utils/app_themes.dart`, `lib/utils/app_colors.dart`, `pubspec.yaml`, `lib/gen/fonts.gen.dart`, `lib/main.dart`.

## Light only

`MaterialApp` sets:

```dart
theme: AppThemes.lightTheme,
```

There is **no** `darkTheme` / `themeMode` wiring in `main.dart`. `AppThemes` documents a dark section header but only defines `lightTheme`.

`lightTheme` (`ThemeData`):

- `brightness: Brightness.light`
- `scaffoldBackgroundColor: AppColors.white`
- `primaryColor` / `ColorScheme.light` primary & secondary → `AppColors.primaryColor`
- Drawer background → `AppColors.primaryColor`
- AppBar icon theme → `AppColors.primaryBlue`
- `fontFamily` line is **commented out** (`// fontFamily: AppConstants.textFontFamily`)

## `AppColors`

Single source of truth in `lib/utils/app_colors.dart`. Groups include brand/primary blues, secondary yellow/orange accents, surfaces, greys, text, semantic status colors, and opacity helpers. File comment: do not use raw `Color` literals or Flutter `Colors` swatches in UI (exception: `Colors.transparent`).

Selected brand values:

| Name | Hex |
|---|---|
| `primaryBlue` | `#485CC7` |
| `primaryColor` | `#617FFF` |
| `secondaryColor` | `#F3CD50` |
| `errorRed` | `#FF2B5F` |
| `successGreen` | `#07CDA5` |

## Fonts: Axiforma & Nunito

Declared in `pubspec.yaml` under `flutter.fonts`:

| Family | Assets (weights) |
|---|---|
| **Axiforma** | Regular (500), Light (400), Bold (700) |
| **Nunito** | Regular (500), Light (400), Bold (700) |

Generated constants: `FontFamily.axiforma` / `FontFamily.nunito` in `lib/gen/fonts.gen.dart`.

Fonts are applied per-widget in places (e.g. `fontFamily: 'Axiforma'` in `CustomStudentInfo`, `fontFamily: 'Nunito'` in `show_message_image.dart`), not as the global `ThemeData.fontFamily`.

> [!warning] Verification Required
> One screen (`app_feedback_screen.dart`) hardcodes `fontFamily: 'Roboto'`; that is outside the declared Axiforma/Nunito families.

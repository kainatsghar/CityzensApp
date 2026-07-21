import 'package:flutter/material.dart';

/// Single source of truth for all application colors.
///
/// Do not use raw [Color] literals or Flutter [Colors] swatches in UI code;
/// add a named constant here instead. [Colors.transparent] is the only
/// intentional exception (framework "no paint" sentinel).
class AppColors {
  AppColors._();

  // =========================
  // Brand / Primary
  // =========================
  static const Color primaryBlue = Color(0xFF485CC7);
  static const Color primaryDarkBlue = Color(0xFF303F9F);
  static const Color primaryColor = Color(0xFF617FFF);
  static const Color primaryLightBlue = Color(0xFFE8ECFF);
  static const Color purple = Color(0xFF4F5FEB);
  static const Color indigoDeep = Color(0xFF1A237E);
  static const Color navyBlue = Color(0xFF003875);
  static const Color indigo = Color(0xFF3F51B5);
  static const Color indigoLight = Color(0xFF5C6BC0);

  // =========================
  // Secondary / Accent
  // =========================
  static const Color secondaryColor = Color(0xFFF3CD50);
  static const Color paleYellow = Color(0xFFFFF6D2);
  static const Color warningOrange = Color(0xFFFBA95D);
  static const Color amber = Color(0xFFFFC107);
  static const Color orange = Color(0xFFFF9800);
  static const Color orangeAccent = Color(0xFFFFAB40);
  static const Color deepOrange = Color(0xFFFF7043);

  // =========================
  // Tertiary
  // =========================
  static const Color tertiaryLight = Color(0xFFD9B38C);
  static const Color tertiaryDark = Color(0xFF7C4F35);

  // =========================
  // Background / Surface
  // =========================
  static const Color white = Color(0xFFFFFFFF);
  static const Color ultraLightGrey = Color(0xFFF7F7F7);
  static const Color slate50 = Color(0xFFF8FAFC);
  static const Color slate100 = Color(0xFFF1F5F9);
  static const Color softBlueGrey = Color(0xFFF6F8FB);
  static const Color softBlueGreyAlt = Color(0xFFF8FAFD);
  static const Color nearWhite = Color(0xFFF0F0F0);

  // =========================
  // Neutrals / Grey scale
  // =========================
  static const Color black = Color(0xFF000000);
  static const Color softGreyText = Color(0xFF6F6F6F);
  static const Color charcoal = Color(0xFF535353);
  static const Color borderGrey = Color(0xFFE5E5E5);
  static const Color grey = Color(0xFFEBEAEA);
  static const Color lightGrey = Color(0xFFC9C9C9);

  /// Material grey shades used across the app (exact Flutter values).
  /// [grey500] is Flutter's default [Colors.grey].
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);

  static const Color blueGrey = Color(0xFF607D8B);
  static const Color blueGreyLight = Color(0xFFECEFF1);

  static const Color neutral50 = Color(0xFFF9FAFB);
  static const Color neutral100 = Color(0xFFF3F4F6);
  static const Color neutral300 = Color(0xFFD1D5DB);
  static const Color neutral500 = Color(0xFF6B7280);
  static const Color neutral700 = Color(0xFF374151);
  static const Color neutral900 = Color(0xFF111827);

  static const Color border = Color(0xFFEDE9E0);
  static const Color darkSurface = Color(0xFF1B1E28);

  // =========================
  // Text
  // =========================
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF4B5563);

  // =========================
  // Status / Semantic
  // =========================
  static const Color errorRed = Color(0xFFFF2B5F);
  static const Color lightRed = Color(0xFFE04D83);
  static const Color softPink = Color(0xFFF5687B);
  static const Color materialRed = Color(0xFFF44336);
  static const Color redAccent = Color(0xFFFF5252);
  static const Color red300 = Color(0xFFE57373);
  static const Color red400 = Color(0xFFEF5350);
  static const Color red700 = Color(0xFFD32F2F);
  static const Color red800 = Color(0xFFC62828);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);

  static const Color successGreen = Color(0xFF07CDA5);
  static const Color materialGreen = Color(0xFF4CAF50);
  static const Color green300 = Color(0xFF81C784);
  static const Color green600 = Color(0xFF43A047);
  static const Color greenAccent = Color(0xFF69F0AE);
  static const Color teal = Color(0xFF26A69A);

  static const Color materialBlue = Color(0xFF2196F3);
  static const Color lightBlue = Color(0xFF42A5F5);

  static const Color softLavender = Color(0xFFE3A5EC);

  // =========================
  // Opacity helpers (const-safe)
  // =========================
  static const Color white10 = Color(0x1AFFFFFF);
  static const Color white12 = Color(0x1FFFFFFF);
  static const Color white15 = Color(0x26FFFFFF);
  static const Color white24 = Color(0x3DFFFFFF);
  static const Color white60 = Color(0x99FFFFFF);
  static const Color white70 = Color(0xB3FFFFFF);
  static const Color white80 = Color(0xCCFFFFFF);
  static const Color white90 = Color(0xE6FFFFFF);
  static const Color white05 = Color(0x0DFFFFFF);

  static const Color black12 = Color(0x1F000000);
  static const Color black20 = Color(0x33000000);
  static const Color black26 = Color(0x42000000);
  static const Color black54 = Color(0x8A000000);

  /// Semi-opaque navy used on profile / feedback surfaces.
  static const Color navyOverlay = Color(0xED002D62);
}

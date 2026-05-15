import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryDarkColor = Color.fromRGBO(48, 63, 159, 1.0);
  static const Color secondaryColor = Color(0xfff3cd50);
  static const Color blackColor = Colors.black;
  static const Color purpleColor = Color(0xff4F5FEB);
  static const Color valuesRedColors = Color(0xffFF2B5F);
  static const Color goldenColors = Color(0xffFBA95D);
  static const Color successGreenColor = Color(0xff07CDA5);
  static const Color lightRedColor = Color(0xffE04D83);
  static const Color whiteColor = Colors.white;
  static const Color primaryColor = Color(0xff617fff);
  static const Color primaryTitleColor = Color(0xff485CC7);
  static const Color greyColor = Color.fromARGB(255, 235, 234, 234);

  // =========================
  // Core Brand Colors
  // =========================
  static const Color primaryBlue = Color(0xFF485CC7); // primaryTitleColor
  static const Color primaryDarkBlue = Color(0xFF303F9F); // primaryDarkColor
  static const Color primaryLightBlue = Color(
    0xFFE8ECFF,
  ); // Light tint for backgrounds

  // =========================
  // Accent Colors
  // =========================
  static const Color goldenYellow = Color(0xFFF3CD50); // secondaryColor
  static const Color paleYellow = Color(0xFFFFF6D2); // soft accent

  // =========================
  // Neutral Colors
  // =========================
  static const Color white = Colors.white; // whiteColor
  static const Color ultraLightGrey = Color(0xFFF7F7F7); // background
  static const Color borderGrey = Color(0xFFE5E5E5); // borders
  static const Color softGreyText = Color(0xFF6F6F6F); // subtext
  static const Color primaryBlackText = Colors.black; // blackColor

  // =========================
  // Status Colors
  // =========================
  static const Color errorRed = Color(0xFFFF2B5F); // valuesRedColors
  static const Color warningOrange = Color(0xFFFBA95D); // goldenColors
  static const Color successGreen = Color(0xFF07CDA5); // successGreenColor
  static const Color lightRed = Color(0xFFE04D83); // lightRedColor

  // =========================
  // Other Brand Variants
  // =========================
  static const Color purple = Color(0xFF4F5FEB); // purpleColor
  static const Color primary = Color(0xFF617FFF); // primaryColor
  static const Color grey = Color(0xFFEBEAEA); // greyColor
  static const Color blueGrey = Color(0xFF607D8B);
  static const Color blueGreyLight = Color(0xFFECEFF1); // shade 50
  static const Color blueGreyDark = Color(0xFF455A64); // shade 700

  // ================================================================
  // ====================== NEW PREMIUM PALETTE ======================
  // ================================================================

  // ====================== BRAND CORE ======================
  // static const Color primary = Color(0xFF303F9F);           // Main Brand Blue (Recommended)
  static const Color primaryLight = Color(0xFF485CC7);
  static const Color primaryDark = Color(0xFF1E2A6B);

  static const Color secondary = Color(
    0xFFF3CD50,
  ); // Gold - Now strongly promoted as Secondary
  static const Color secondaryDark = Color(0xFFDBB13F);
  static const Color secondaryLight = Color(
    0xFFFFF6D2,
  ); // Use for large backgrounds/sections

  static const Color tertiary = Color(
    0xFF9C6644,
  ); // Warm Terracotta (New Tertiary)
  static const Color tertiaryLight = Color(0xFFD9B38C);
  static const Color tertiaryDark = Color(0xFF7C4F35);

  // ====================== NEUTRALS & BACKGROUND ======================
  static const Color background = Color(0xFFF8F7F4); // Warm elegant off-white
  static const Color surface = Color(0xFFFFFFFF);
  static const Color card = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFEDE9E0);

  static const Color darkNavy = Color(0xFF1A2338);
  static const Color neutral900 = Color(0xFF111827);
  static const Color neutral700 = Color(0xFF374151);
  static const Color neutral500 = Color(0xFF6B7280);
  static const Color neutral300 = Color(0xFFD1D5DB);
  static const Color neutral100 = Color(0xFFF3F4F6);
  static const Color neutral50 = Color(0xFFF9FAFB);

  // ====================== TEXT COLORS ======================
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF4B5563);
  static const Color textTertiary = Color(0xFF6B7280);
  static const Color textOnPrimary = Colors.white;
  static const Color textOnSecondary = Color(0xFF1F2937); // Dark text on gold
  static const Color textOnDark = Colors.white;

  // ====================== SEMANTIC / STATUS COLORS ======================
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFD1FAE5);

  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);

  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);

  static const Color info = Color(0xFF3B82F6);

  // ====================== GRADIENTS HELPERS ======================
  static const Color gradientBlueStart = Color(0xFF303F9F);
  static const Color gradientBlueEnd = Color(0xFF1E2A6B);

  static const Color gradientGoldStart = Color(0xFFF3CD50);
  static const Color gradientGoldEnd = Color(0xFFDBB13F);
}

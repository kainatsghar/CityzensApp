import 'package:flutter/material.dart';

class AppColors {
  // ==========================================
  // Cityzens 2.0 Design Tokens (from HTML mockup)
  // ==========================================
  static const Color blue = Color(0xFF194F90);         // Royal TCS Blue (primary)
  static const Color blueDeep = Color(0xFF0F3466);     // Dark TCS Blue
  static const Color blueTint = Color(0xFFE8EFF8);     // Soft blue background tint
  static const Color yellow = Color(0xFFFFE800);       // TCS Accent Yellow
  static const Color yellowDeep = Color(0xFFD9C400);   // Dark Yellow (active / hover)
  static const Color paper = Color(0xFFF3F5F8);        // Scaffold canvas background
  static const Color card = Color(0xFFFFFFFF);         // Card white surface
  static const Color ink = Color(0xFF1B2333);          // High-contrast primary text
  static const Color muted = Color(0xFF586377);        // Secondary/muted text
  static const Color line = Color(0xFFE1E6ED);         // Borders and dividers

  // Status & Feedback Tokens
  static const Color green = Color(0xFF2ECC71);        // Success / Present
  static const Color red = Color(0xFFE74C3C);          // Danger / Absent
  static const Color leave = Color(0xFFFFC94D);        // Leave / Warning

  // ==========================================
  // Backward-Compatible Core Brand Colors
  // ==========================================
  static const Color primaryColor = blue;              // 0xFF194F90
  static const Color primaryDarkColor = blueDeep;      // 0xFF0F3466
  static const Color primaryTitleColor = blue;
  static const Color secondaryColor = yellow;          // 0xFFFFE800
  static const Color goldenColors = yellow;
  static const Color goldenYellow = yellow;
  static const Color paleYellow = Color(0xFFFFF9D2);

  static const Color primaryBlue = blue;
  static const Color primaryDarkBlue = blueDeep;
  static const Color primaryLightBlue = blueTint;

  // ==========================================
  // Backward-Compatible Neutral & Text Colors
  // ==========================================
  static const Color whiteColor = Colors.white;
  static const Color white = Colors.white;
  static const Color blackColor = ink;
  static const Color primaryBlackText = ink;
  static const Color softGreyText = muted;
  static const Color ultraLightGrey = paper;
  static const Color borderGrey = line;
  static const Color greyColor = Color(0xFFE5E7EB);
  static const Color grey = Color(0xFFE5E7EB);

  // ==========================================
  // Backward-Compatible Status Colors
  // ==========================================
  static const Color successGreenColor = green;
  static const Color successGreen = green;
  static const Color valuesRedColors = red;
  static const Color errorRed = red;
  static const Color lightRedColor = Color(0xFFE04D83);
  static const Color lightRed = Color(0xFFE04D83);
  static const Color warningOrange = leave;

  // ==========================================
  // Other Variants
  // ==========================================
  static const Color purpleColor = Color(0xFF4F5FEB);
  static const Color purple = Color(0xFF4F5FEB);
  static const Color primary = blue;
}

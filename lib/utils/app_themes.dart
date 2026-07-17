import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppThemes {
  /// Dark Theme Settings

  /// Light Theme Settings
  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.whiteColor,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    brightness: Brightness.light,
    primaryColor: AppColors.primaryColor,
    // fontFamily: AppConstants.textFontFamily,
    drawerTheme: const DrawerThemeData(backgroundColor: AppColors.primaryColor),
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(color: AppColors.primaryTitleColor),
    ),
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryColor,
      secondary: AppColors.primaryColor,
    ),
  );
}

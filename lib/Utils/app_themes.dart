import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppThemes {
  /// Dark Theme Settings

  /// Light Theme Settings
  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.whiteColor,
    brightness: Brightness.light,
    primaryColor: AppColors.primaryColor,
   // fontFamily: AppConstants.textFontFamily,
    drawerTheme: DrawerThemeData(backgroundColor: AppColors.primaryColor),
    appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(color: AppColors.primaryTitleColor)),
    colorScheme: ColorScheme.light(
        primary: AppColors.primaryColor, secondary: AppColors.primaryColor),
  );
}

import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppThemes {
  /// Dark Theme Settings

  /// Light Theme Settings
  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.whiteColor,
    brightness: Brightness.light,
    primaryColor: AppColors.primaryColor,
    colorScheme: ColorScheme.light(primary: AppColors.primaryColor),
  );
}

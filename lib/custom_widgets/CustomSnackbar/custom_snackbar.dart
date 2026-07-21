import 'package:flutter/material.dart';
import 'package:tcs_app/routes/app_navigation.dart';
import '../../utils/app_colors.dart';

dynamic showSnackBar(dynamic message, {Color? color}) =>
    ScaffoldMessenger.of(AppNavigation.currentContext!).showSnackBar(
      SnackBar(
        content: Text(
          '$message',
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.white),
        ),
        backgroundColor: color ?? AppColors.softPink,
        duration: const Duration(seconds: 2),
      ),
    );

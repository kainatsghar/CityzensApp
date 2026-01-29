import 'package:flutter/material.dart';
import 'package:tcs_app/routes/app_navigation.dart';
import '../../utils/app_colors.dart';

dynamic showSnackBar(dynamic message, {Color? color}) =>
    ScaffoldMessenger.of(AppNavigation.currentContext!).showSnackBar(
      SnackBar(
        content: Text(
          '$message',
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.whiteColor),
        ),
        backgroundColor: color ?? const Color.fromRGBO(245, 104, 123, 1),
        duration: const Duration(seconds: 2),
      ),
    );

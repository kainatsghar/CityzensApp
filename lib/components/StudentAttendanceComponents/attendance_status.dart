import 'package:flutter/material.dart';
import 'package:tcs_app/utils/app_colors.dart';

class AttendanceStatus extends StatelessWidget {
  final Color? backgroundColor;
  final String? day;
  final Color? textColor;

  const AttendanceStatus({
    super.key,
    required this.backgroundColor,
    required this.day,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: backgroundColor ?? AppColors.white,
      child: Text(
        day ?? '',
        style: TextStyle(color: textColor ?? AppColors.black),
      ),
    );
  }
}

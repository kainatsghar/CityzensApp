import 'package:flutter/material.dart';
import 'package:tcs_app/utils/app_colors.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const CustomListTile({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: AppColors.white,
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: onTap,
    );
  }
}

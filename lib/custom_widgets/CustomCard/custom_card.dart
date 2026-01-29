import 'package:flutter/material.dart';
import 'package:tcs_app/utils/app_colors.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.primaryLightBlue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20.0),
        child: child,
      ),
    );
  }
}

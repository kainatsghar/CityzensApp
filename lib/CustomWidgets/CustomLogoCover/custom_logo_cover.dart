import 'package:flutter/material.dart';
import '../../Utils/app_colors.dart';

class CustomLogoCover extends StatelessWidget {
  const CustomLogoCover({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Card(
      margin: EdgeInsets.zero,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Container(
        width: size.width - 32,
        height: size.height * 0.25,
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Image.asset('assets/images/tcs_logo_white.png'),
      ),
    );
  }
}

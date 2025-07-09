import 'package:flutter/material.dart';
import 'package:tcs_app/Utils/app_colors.dart';

class CustomAppButton extends StatelessWidget {
  final String buttonTitle;
  final VoidCallback onTap;

  const CustomAppButton(
      {super.key, required this.buttonTitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            minimumSize: Size(size.width * 0.85, 45.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0))),
        onPressed: onTap,
        child: Text(buttonTitle,
            style: const TextStyle(fontSize: 20, color: AppColors.whiteColor)));
  }
}

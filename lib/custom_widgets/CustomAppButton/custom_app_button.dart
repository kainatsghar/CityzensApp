import 'package:flutter/material.dart';
import 'package:tcs_app/utils/app_colors.dart';

class CustomAppButton extends StatelessWidget {
  final String buttonTitle;
  final VoidCallback onTap;
  final double? width;

  const CustomAppButton({
    super.key,
    required this.buttonTitle,
    required this.onTap,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 8,
        backgroundColor: AppColors.primaryColor,
        minimumSize: Size(width ?? size.width * 0.85, 45.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      onPressed: onTap,
      child: Text(
        buttonTitle,
        style: const TextStyle(fontSize: 20, color: AppColors.whiteColor),
      ),
    );
  }
}

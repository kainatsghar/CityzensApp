import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class CustomLogoCover extends StatelessWidget {
  const CustomLogoCover({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return FadeInDown(
      duration: const Duration(milliseconds: 600),
      child: Container(
        width: size.width - 32,
        height: size.height * 0.22,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primaryColor, AppColors.primaryDarkBlue],
          ),
          borderRadius: BorderRadius.circular(24.0),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryBlue.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.0),
          child: Stack(
            children: [
              Positioned(
                top: -20,
                right: -20,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: AppColors.white.withValues(alpha: 0.05),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Image.asset(
                    'assets/images/tcs_logo_white.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

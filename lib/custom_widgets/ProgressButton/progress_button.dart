import 'package:flutter/material.dart';
import 'package:tcs_app/custom_widgets/ProgressButton/progress_border_painter.dart';
import 'package:tcs_app/routes/app_navigation.dart';
import 'package:tcs_app/utils/app_colors.dart';

class ProgressButton extends StatelessWidget {
  const ProgressButton({
    super.key,
    required this.progress,
    required this.routeName,
  });

  final double progress;
  final String routeName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 40,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: CustomPaint(
        painter: ProgressBorderPainter(
          progress: progress,
          primaryColor: AppColors.secondaryColor,
          radius: 20,
          backgroundColor: AppColors.white.withValues(alpha: 0.3),
        ),
        child: Container(
          margin: const EdgeInsets.all(2), // Space for the border
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () {
                AppNavigation.pushReplacementTo(routeName);
              },
              child: const Center(
                child: Text(
                  'Skip',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

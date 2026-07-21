import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:tcs_app/utils/app_colors.dart';

class CustomPercentageBar extends StatelessWidget {
  final double barWidth;
  final double barHeight;
  final String barValue;

  const CustomPercentageBar({
    super.key,
    required this.barWidth,
    required this.barHeight,
    required this.barValue,
  });

  @override
  Widget build(BuildContext context) {
    return LinearPercentIndicator(
      width: barWidth,
      lineHeight: barHeight,
      percent: barValue == '-' ? 0.0 : double.parse(barValue) * 0.01,
      progressColor: barValue == '-'
          ? AppColors.grey500
          : double.parse(barValue) * 0.01 < 0.3
          ? AppColors.materialRed
          : double.parse(barValue) * 0.01 < 0.5
          ? AppColors.orangeAccent
          : AppColors.materialGreen,
    );
  }
}

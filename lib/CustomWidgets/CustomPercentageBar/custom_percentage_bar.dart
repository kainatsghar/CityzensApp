import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class CustomPercentageBar extends StatelessWidget {
  final double barWidth;
  final double barHeight;
  final String barValue;

  const CustomPercentageBar({Key key, this.barWidth, this.barHeight, this.barValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LinearPercentIndicator(
      width: barWidth,
      lineHeight: barHeight,
      percent: barValue == '-' ? 0.0 : double.parse(barValue) * 0.01,
      progressColor: barValue == '-'
          ? Colors.grey
          : double.parse(barValue) * 0.01 < 0.3
              ? Colors.red
              : double.parse(barValue) * 0.01 < 0.5
                  ? Colors.orangeAccent
                  : Colors.green,
    );
  }
}

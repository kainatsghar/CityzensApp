import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

class CustomDivider extends StatelessWidget {
  final double? horizontalPadding;
  final Color? color;

  const CustomDivider({super.key, this.horizontalPadding, this.color});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding ?? size.width * 0.15,
      ),
      child: Divider(
        height: 2.0,
        thickness: 3.0,
        color: color ?? AppColors.primaryDarkBlue,
      ),
    );
  }
}

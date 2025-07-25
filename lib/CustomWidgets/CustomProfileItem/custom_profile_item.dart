import 'package:flutter/material.dart';
import 'package:tcs_app/Utils/app_colors.dart';

import '../../Utils/helper_function.dart';

class CustomProfileItem extends StatelessWidget {
  final double? width;
  final String? title;
  final String? value;
  final int? maxLines;
  final BorderRadiusGeometry? borderRadius;

  const CustomProfileItem({
    super.key,
    this.width,
    this.title,
    this.value,
    this.borderRadius,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(0.0),
      ),
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        decoration: BoxDecoration(
          color: AppColors.secondaryColor,
          borderRadius: borderRadius,
        ),
        child: Column(
          children: <Widget>[
            Text(
              '$title',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryTitleColor,
              ),
              textAlign: TextAlign.center,
            ),
            const Padding(padding: EdgeInsets.only(top: 5.0)),
            Text(
              HelperFunction.noNullStringText(value),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54),
              maxLines: maxLines ?? 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

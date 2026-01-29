import 'package:flutter/material.dart';
import 'package:tcs_app/utils/app_colors.dart';
import 'package:tcs_app/utils/media_query_util.dart';

import '../../utils/helper_function.dart';

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
          color: AppColors.primaryLightBlue,
          borderRadius: borderRadius,
        ),
        child: Column(
          children: <Widget>[
            Text(
              '$title',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryTitleColor,
                fontSize: MediaQueryUtil.getResponsiveFontSize(14),
              ),
              textAlign: TextAlign.center,
            ),
            const Padding(padding: EdgeInsets.only(top: 5.0)),
            Text(
              HelperFunction.noNullStringText(value),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black54,
                fontSize: MediaQueryUtil.getResponsiveFontSize(12),
              ),
              maxLines: maxLines ?? 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

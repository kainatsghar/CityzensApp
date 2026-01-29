import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:tcs_app/utils/app_colors.dart';
import 'package:tcs_app/utils/media_query_util.dart';

class CustomDashboardButton extends StatelessWidget {
  final VoidCallback? onTap; // Made nullable to disable the button
  final String imageName;
  final String? title;
  final double? leftAlign;
  final double? bottomAlign;
  final double? imageHeight;

  const CustomDashboardButton({
    super.key,
    this.onTap, // onTap is optional now
    required this.imageName,
    this.title,
    this.leftAlign,
    this.bottomAlign,
    this.imageHeight,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: FadeInUp(
        child: Card(
          color: onTap == null ? Colors.grey : AppColors.primaryLightBlue,
          elevation: 4,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0, top: 8),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize
                          .min, // Ensures the text doesn't take more space than necessary
                      children: [
                        Text(
                          title ?? 'HOMEWORK\nDIARY', // Display the title text
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                            color: AppColors.primaryTitleColor,
                          ),
                        ),
                        if (onTap == null) // Show "Coming Soon" if disabled
                          const Padding(
                            padding: EdgeInsets.only(
                              top: 4.0,
                            ), // Adds space between title and "Coming Soon"
                            child: Text(
                              'COMING SOON',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: bottomAlign ?? -15,
                  left: leftAlign ?? -5,
                  child: Image.asset(
                    'assets/images/$imageName',
                    height:
                        imageHeight ??
                        MediaQueryUtil.getResponsivePercentageSize(12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

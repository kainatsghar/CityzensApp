import 'package:flutter/material.dart';
import 'package:tcs_app/Utils/app_colors.dart';

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
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(right: 8.0, top: 8),
              color: onTap == null
                  ? Colors.grey
                  : AppColors.secondaryColor, // Set to grey if disabled
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
                        color: AppColors.primaryTitleColor,
                      ),
                    ),
                    if (onTap == null) // Show "Coming Soon" if disabled
                      const Padding(
                        padding: EdgeInsets.only(
                            top:
                                4.0), // Adds space between title and "Coming Soon"
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
                'images/$imageName',
                height: imageHeight ?? size.height * 0.12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

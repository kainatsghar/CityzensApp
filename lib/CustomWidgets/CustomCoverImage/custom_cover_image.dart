import 'package:flutter/material.dart';

import '../../Utils/app_colors.dart';

class CustomCoverImage extends StatelessWidget {
  final String imagePath;
  final String title;

  const CustomCoverImage({
    super.key,
    required this.title,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Card(
      margin: EdgeInsets.zero,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Container(
        width: size.width - 32,
        height: size.height * 0.25,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Image.asset(
                  'assets/images/$imagePath',
                  height: size.height * 0.15,
                  alignment: Alignment.bottomCenter,
                ),
              ],
            ),
            // const SizedBox(height: 8.0),
            Text(
              title,
              style: const TextStyle(
                fontSize: 23.0,
                letterSpacing: 1.5,
                color: AppColors.whiteColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

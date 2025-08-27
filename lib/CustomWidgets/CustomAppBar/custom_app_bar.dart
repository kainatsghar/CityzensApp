import 'package:flutter/material.dart';
import 'package:tcs_app/Utils/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? actions;
  final String title;
  final double appBarHeight;

  const CustomAppBar({
    super.key,
    this.actions,
    this.title = '',
    this.appBarHeight = 56.0,
  });

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: AppColors.whiteColor,
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18.0,
          color: AppColors.primaryTitleColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions:
          actions ??
          [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: SizedBox(
                height: 48,
                width: 48,
                child: Image.asset('assets/images/tcs_logo.png'),
              ),
            ),
          ],
    );
  }
}

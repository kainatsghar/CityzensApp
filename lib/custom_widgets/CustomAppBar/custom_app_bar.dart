import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tcs_app/utils/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? actions;
  final String title;
  final double appBarHeight;
  final Color backgroundColor;
  final void Function()? onBackPressed;

  const CustomAppBar({
    super.key,
    this.actions,
    this.title = '',
    this.backgroundColor = AppColors.white,
    this.appBarHeight = 56.0,
    this.onBackPressed,
  });

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: backgroundColor,
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18.0,
          color: AppColors.primaryBlue,
          fontWeight: FontWeight.w600,
        ),
      ),
      leading: onBackPressed == null
          ? null
          : IconButton(
              icon: Icon(
                Platform.isAndroid
                    ? Icons.arrow_back
                    : Icons.arrow_back_ios_new,
                color: AppColors.primaryBlue,
              ),
              onPressed: onBackPressed,
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

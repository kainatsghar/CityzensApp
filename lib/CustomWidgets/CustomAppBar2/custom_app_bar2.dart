import 'package:flutter/material.dart';
import 'package:tcs_app/Utils/app_colors.dart';

class CustomAppBar2 extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? actions;
  final String title;
  final double appBarHeight;
  final Widget? flexibleSpace;

  const CustomAppBar2({
    super.key,
    this.actions,
    this.title = '',
    this.appBarHeight = 56.0,
    this.flexibleSpace,
  });

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar.large(
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
      flexibleSpace: flexibleSpace,
      actions:
          actions ??
          [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: SizedBox(
                height: 48,
                width: 48,
                child: Image.asset('images/tcs_logo.png'),
              ),
            ),
          ],
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tcs_app/CustomWidgets/CustomAppBar/cityzens_menu_button.dart';
import 'package:tcs_app/Utils/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? actions;
  final String title;
  final double appBarHeight;
  final Color backgroundColor;
  final void Function()? onBackPressed;
  final Widget? leading;

  const CustomAppBar({
    super.key,
    this.actions,
    this.title = '',
    this.backgroundColor = AppColors.whiteColor,
    this.appBarHeight = 56.0,
    this.onBackPressed,
    this.leading,
  });

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: backgroundColor,
      centerTitle: true,
      iconTheme: IconThemeData(
        color: backgroundColor == AppColors.whiteColor
            ? AppColors.blue
            : Colors.white,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18.0,
          color: AppColors.primaryTitleColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      leading: leading ??
          (onBackPressed != null
              ? IconButton(
                  icon: Icon(
                    Platform.isAndroid
                        ? Icons.arrow_back
                        : Icons.arrow_back_ios_new,
                    color: AppColors.primaryTitleColor,
                  ),
                  onPressed: onBackPressed,
                )
              : Builder(
                  builder: (context) {
                    final hasDrawer =
                        Scaffold.maybeOf(context)?.hasDrawer ?? false;
                    if (hasDrawer) {
                      return Center(
                        child: CityzensMenuButton(
                          size: 38.0,
                          onTap: () => Scaffold.of(context).openDrawer(),
                        ),
                      );
                    }
                    final canPop = ModalRoute.of(context)?.canPop ?? false;
                    if (canPop) {
                      return IconButton(
                        icon: Icon(
                          Platform.isAndroid
                              ? Icons.arrow_back
                              : Icons.arrow_back_ios_new,
                          color: AppColors.primaryTitleColor,
                        ),
                        onPressed: () => Navigator.of(context).maybePop(),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                )),
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

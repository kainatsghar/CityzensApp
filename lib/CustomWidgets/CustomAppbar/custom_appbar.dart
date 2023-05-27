import 'package:flutter/material.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Utils/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget> actions;
  final String title;
  final double appBarHeight;
  final bool isDrawer;

  const CustomAppBar(
      {Key key,
      this.actions,
      this.title = '',
      this.appBarHeight = 56.0,
      this.isDrawer = false})
      : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        elevation: 0.0,
        backgroundColor: AppColors.whiteColor,
        centerTitle: true,
        title: new Text('$title',
            style: TextStyle(
                fontSize: 22.0,
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w600)),
        leading: isDrawer
            ? null
            : !AppNavigation.canPop()
                ? Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Image.asset('images/tcs_logo.png'))
                : null,
        actions: actions ??
            [
              !AppNavigation.canPop()
                  ? SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset('images/tcs_logo.png'))
            ]);
  }
}

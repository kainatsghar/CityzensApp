import 'package:flutter/material.dart';
import 'package:tcs_app/Utils/app_colors.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const CustomListTile({Key key, this.title, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text('$title',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: AppColors.whiteColor,
                fontSize: 16.0,
                fontWeight: FontWeight.w600)),
        onTap: onTap);
  }
}

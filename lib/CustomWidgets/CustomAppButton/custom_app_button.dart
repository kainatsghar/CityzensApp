import 'package:flutter/material.dart';
import 'package:tcs_app/Utils/app_colors.dart';

class CustomAppButton extends StatelessWidget {
  final String buttonTitle;
  final VoidCallback onTap;

  const CustomAppButton({Key key, this.buttonTitle, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            minimumSize: Size(size.width * 0.85, 45.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0))),
        child: Text('$buttonTitle',
            style: TextStyle(fontSize: 20, color: AppColors.whiteColor)),
        onPressed: onTap);
  }
}

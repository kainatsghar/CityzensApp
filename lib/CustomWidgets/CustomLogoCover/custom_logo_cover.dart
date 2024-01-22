import 'package:flutter/material.dart';
import '../../Utils/app_colors.dart';

class CustomLogoCover extends StatelessWidget {
  const CustomLogoCover({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height * 0.25,
      padding: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(20.0)),
      child: Image.asset('images/tcs_logo_white.png'),
    );
  }
}

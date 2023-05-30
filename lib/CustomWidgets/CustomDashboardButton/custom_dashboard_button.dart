import 'package:flutter/material.dart';
import 'package:tcs_app/Utils/app_colors.dart';

class CustomDashboardButton extends StatelessWidget {
  final VoidCallback onTap;
  final String imageName;
  final String title;
  final double leftAlign;
  final double bottomAlign;
  final double imageHeight;

  const CustomDashboardButton(
      {Key key,
      this.onTap,
      this.imageName,
      this.title,
      this.leftAlign,
      this.bottomAlign,
      this.imageHeight})
      : super(key: key);

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
                  padding: EdgeInsets.only(right: 8.0, top: 8),
                  color: AppColors.secondaryColor,
                  child: Align(
                      alignment: Alignment.topRight,
                      child: Text(title ?? 'HOMEWORK\nDIARY',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryTitleColor)))),
              Positioned(
                  bottom: bottomAlign ?? -15,
                  left: leftAlign ?? -5,
                  child: Image.asset('images/$imageName',
                      height: imageHeight ?? size.height * 0.12)),
            ],
          ),
        ));
  }
}

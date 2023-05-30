import 'package:flutter/material.dart';

import '../../Utils/app_colors.dart';

class CustomCoverImage extends StatelessWidget {
  final String imagePath;
  final String title;

  const CustomCoverImage(
      {Key key, @required this.title, @required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.9,
      height: size.height * 0.25,
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(20.0)),
      child: Column(
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 25.0,
                  letterSpacing: 2.0,
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: size.height * 0.02),
          Flexible(child: Image.asset('images/$imagePath'))
        ],
      ),
    );
  }
}

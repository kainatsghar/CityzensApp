import 'package:flutter/material.dart';

class CustomDashboardButton extends StatelessWidget {
  final VoidCallback onTap;
  final String imageName;

  const CustomDashboardButton(
      {Key key, this.onTap, this.imageName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
        onTap: onTap,
        child: Container(child: Image.asset('images/$imageName',fit: BoxFit.cover,)));
  }
}
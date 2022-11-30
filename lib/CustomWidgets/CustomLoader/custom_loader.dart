import 'package:flutter/material.dart';

class CustomLoader extends StatelessWidget {
  final double height, width;

  const CustomLoader({Key key, this.height = 42, this.width = 42})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Image.asset("images/loading.gif", height: height, width: width));
  }
}

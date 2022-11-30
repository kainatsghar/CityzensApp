import 'package:flutter/material.dart';
import 'package:tcs_app/Utils/app_colors.dart';

class CustomProfileItem extends StatelessWidget {
  final double width;
  final String title;
  final String value;

  const CustomProfileItem({Key key, this.width, this.title, this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        child: Column(children: <Widget>[
          Text(value == 'null' || value == null ? '-' : '$value',
              style: TextStyle(color: Colors.black54)),
          Padding(padding: EdgeInsets.only(top: 5.0)),
          Text('$title',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: AppColors.blackColor),
              textAlign: TextAlign.center)
        ]));
  }
}

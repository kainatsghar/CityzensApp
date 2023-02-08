import 'package:flutter/material.dart';

class AttendanceLegends extends StatelessWidget {
  final Color color;
  final String title;

  const AttendanceLegends({Key key, @required this.color, @required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(backgroundColor: color, radius: 10),
        SizedBox(width: 10),
        Text(title),
        SizedBox(width: 10)
      ],
    );
  }
}

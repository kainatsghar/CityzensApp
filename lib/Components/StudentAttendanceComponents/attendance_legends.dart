import 'package:flutter/material.dart';

class AttendanceLegends extends StatelessWidget {
  final Color color;
  final String title;

  const AttendanceLegends({
    super.key,
    required this.color,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(backgroundColor: color, radius: 10),
        const SizedBox(width: 10),
        Text(title),
        const SizedBox(width: 10),
      ],
    );
  }
}

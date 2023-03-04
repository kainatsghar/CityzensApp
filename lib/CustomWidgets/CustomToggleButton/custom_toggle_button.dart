import 'package:flutter/material.dart';
import 'package:tcs_app/model/StudentAttendance/student_list_response.dart';

class CustomToggleButton extends StatelessWidget {
  final Student student;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const CustomToggleButton(
      {Key key, this.student, this.title, this.color, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Container(
          decoration: BoxDecoration(
              color: student.day == title
                  ? color.withOpacity(0.5)
                  : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2.0)),
          height: size.width / 12,
          width: size.width / 12,
          child: Center(
            child: Text(title,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w600)),
          )),
    );
  }
}

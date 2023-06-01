import 'package:flutter/material.dart';

class CustomSubjectGrade extends StatelessWidget {
  final String grade;

  const CustomSubjectGrade({Key key, this.grade}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String subjectGrade = grade.toLowerCase();
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Image.asset(subjectGrade == 'a'
          ? 'images/a_grade.png'
          : subjectGrade == 'a*'
              ? 'images/as_grade.png'
              : subjectGrade == 'b'
                  ? 'images/b_grade.png'
                  : subjectGrade == 'c'
                      ? 'images/c_grade.png'
                      : subjectGrade == 'd'
                          ? 'images/d_grade.png'
                          : subjectGrade == 'e'
                              ? 'images/e_grade.png'
                              : 'images/u_grade.png'),
    );
  }
}

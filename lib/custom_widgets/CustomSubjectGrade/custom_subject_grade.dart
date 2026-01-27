import 'package:flutter/material.dart';

class CustomSubjectGrade extends StatelessWidget {
  final String grade;

  const CustomSubjectGrade({super.key, required this.grade});

  @override
  Widget build(BuildContext context) {
    String subjectGrade = grade.toLowerCase();
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Image.asset(
        subjectGrade == 'a'
            ? 'assets/images/a_grade.png'
            : subjectGrade == 'a*'
            ? 'assets/images/as_grade.png'
            : subjectGrade == 'b'
            ? 'assets/images/b_grade.png'
            : subjectGrade == 'c'
            ? 'assets/images/c_grade.png'
            : subjectGrade == 'd'
            ? 'assets/images/d_grade.png'
            : subjectGrade == 'e'
            ? 'assets/images/e_grade.png'
            : 'assets/images/no_grade.png',
      ),
    );
  }
}

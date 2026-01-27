import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../custom_widgets/CustomTestResultFormField/custom_test_result_form_field.dart';
import '../../Model/ClassTestResult/class_test_student_list_response.dart';
import '../../Provider/ClassTestResult/class_test_result_provider.dart';

class StudentListItem extends StatelessWidget {
  final ClassTestStudent student;
  final int index;

  const StudentListItem({
    super.key,
    required this.student,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ClassTestResultProvider>(
      builder: (context, value, _) {
        return Card(
          child: ListTile(
            title: Text(
              student.studentName!.toUpperCase(),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            //subtitle: Text(student.studentId.toString()),
            trailing: const Padding(
              padding: EdgeInsets.only(top: 10, right: 0, bottom: 10, left: 25),
              child: CustomTestResultFormField(inputType: TextInputType.number),
            ),
          ),
        );
      },
    );
  }
}

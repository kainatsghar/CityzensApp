import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Components/StudentAttendanceComponents/attendance_legends.dart';
import 'package:tcs_app/Components/StudentAttendanceComponents/student_attendance.dart';

import '../../CustomWidgets/CustomStudentInfo/custom_student_info.dart';
import '../../Provider/Library/library_provider.dart';

class StudentAttendanceComponent extends StatelessWidget {
  const StudentAttendanceComponent({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<LibraryProvider>(builder: (context, value, _) {
        return SingleChildScrollView(
            child: Column(children: [
          CustomStudentInfo(info: value.libraryResponse.info),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0,left: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AttendanceLegends(
                      color: Colors.green.withOpacity(0.9), title: "Present"),
                  AttendanceLegends(
                      color: Colors.red.withOpacity(0.9), title: "Absent"),
                  AttendanceLegends(
                      color: Colors.amber.withOpacity(0.9), title: "Leave"),
                ],
              ),
            ),
          ),
          StudentAttendance(),
        ]));
      }),
    );
  }
}

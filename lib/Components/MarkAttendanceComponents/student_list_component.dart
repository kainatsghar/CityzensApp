import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Components/MarkAttendanceComponents/attendance_graph_component.dart';
import 'package:tcs_app/Components/MarkAttendanceComponents/attendance_list_item.dart';
import 'package:tcs_app/CustomWidgets/CustomAppButton/custom_app_button.dart';
import 'package:tcs_app/CustomWidgets/ShowCustomMessage/show_custom_message.dart';
import 'package:tcs_app/Provider/MarkAttendance/mark_attendance_provider.dart';
import 'package:tcs_app/Utils/app_constants.dart';

class StudentListComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<MarkAttendanceProvider>(builder: (context, value, _) {
        var studentList = value.studentListResponse.studentList;
        return studentList.isEmpty
            ? ShowCustomMessage(message: AppConstants.noRecordFound)
            : value.saveAttendanceResponse.isSuccessful != null &&
                    value.saveAttendanceResponse.isSuccessful
                ? AttendanceGraphComponent()
                : ListView.builder(
                    itemCount: studentList.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == studentList.length) {
                        return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10),
                            child: CustomAppButton(
                                buttonTitle: 'Save Attendance',
                                onTap: () => value.saveAttendance()));
                      } else {
                        return AttendanceListItem(
                            index: index, student: studentList[index]);
                      }
                    });
      }),
    );
  }
}

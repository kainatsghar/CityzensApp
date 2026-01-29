import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/components/MarkAttendanceComponents/attendance_graph_component.dart';
import 'package:tcs_app/components/MarkAttendanceComponents/attendance_list_item.dart';
import 'package:tcs_app/custom_widgets/CustomAppButton/custom_app_button.dart';
import 'package:tcs_app/custom_widgets/ShowCustomMessage/show_custom_message.dart';
import 'package:tcs_app/provider/MarkAttendance/mark_attendance_provider.dart';
import 'package:tcs_app/utils/app_constants.dart';

class StudentListComponent extends StatelessWidget {
  const StudentListComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        child: Consumer<MarkAttendanceProvider>(
          builder: (context, value, _) {
            var studentList = value.studentListResponse.studentList;
            return studentList!.isEmpty
                ? const ShowCustomMessage(message: AppConstants.noRecordFound)
                : value.saveAttendanceResponse!.isSuccessful != null &&
                      value.saveAttendanceResponse!.isSuccessful!
                // : value.saveAttendanceResponse!.isSuccessful!
                ? const AttendanceGraphComponent()
                : ListView.builder(
                    itemCount: studentList.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == studentList.length) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 16,
                          ),
                          child: CustomAppButton(
                            buttonTitle: 'Save Attendance',
                            onTap: () => value.saveAttendance(),
                          ),
                        );
                      } else {
                        return AttendanceListItem(
                          index: index,
                          student: studentList[index],
                        );
                      }
                    },
                  );
          },
        ),
      ),
    );
  }
}

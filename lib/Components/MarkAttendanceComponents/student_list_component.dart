// === UPDATED FILE: student_list_component.dart ===
// Modernized: Premium list layout with sticky bottom button,
// consistent padding, and smooth transitions.
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
    return Consumer<MarkAttendanceProvider>(
      builder: (context, value, _) {
        var studentList = value.studentListResponse.studentList;
        return studentList!.isEmpty
            ? const ShowCustomMessage(message: AppConstants.noRecordFound)
            : value.saveAttendanceResponse!.isSuccessful != null &&
                  value.saveAttendanceResponse!.isSuccessful!
            ? const AttendanceGraphComponent()
            : Column(
                children: [
                  // ── Student List ──
                  Expanded(
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                      itemCount: studentList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return AttendanceListItem(
                          index: index,
                          student: studentList[index],
                        );
                      },
                    ),
                  ),

                  // ── Sticky Save Button ──
                  SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      child: CustomAppButton(
                        buttonTitle: 'Save Attendance',
                        onTap: () => value.saveAttendance(),
                      ),
                    ),
                  ),
                ],
              );
      },
    );
  }
}

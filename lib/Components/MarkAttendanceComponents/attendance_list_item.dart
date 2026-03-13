import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/CustomToggleButton/custom_toggle_button.dart';
import 'package:tcs_app/provider/MarkAttendance/mark_attendance_provider.dart';
import 'package:tcs_app/utils/helper_function.dart';
import 'package:tcs_app/model/Options/options.dart';
import 'package:tcs_app/model/StudentAttendance/student_list_response.dart';

class AttendanceListItem extends StatelessWidget {
  final Student student;
  final int index;

  const AttendanceListItem({
    super.key,
    required this.student,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    List<Options> attendanceOptions = HelperFunction.attendanceOptions();
    return Consumer<MarkAttendanceProvider>(
      builder: (context, value, _) {
        return Card(
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
            leading: const Image(
              image: AssetImage('assets/images/profile_avatar.png'),
              fit: BoxFit.cover,
            ),
            title: Text(
              student.name!.toUpperCase(),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(student.studentId.toString()),
            trailing: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              spacing: 4,
              children: List.generate(
                !student.status!
                    ? attendanceOptions.length - 1
                    : attendanceOptions.length,
                (i) => CustomToggleButton(
                  student: student,
                  title: attendanceOptions[i].title!.characters.first,
                  color: attendanceOptions[i].color!,
                  onTap: () => value.changeStatus(
                    attendanceOptions[i].title!.characters.first,
                    index,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

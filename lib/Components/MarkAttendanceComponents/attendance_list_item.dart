import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomToggleButton/custom_toggle_button.dart';
import 'package:tcs_app/Provider/MarkAttendance/mark_attendance_provider.dart';
import 'package:tcs_app/Utils/helper_function.dart';
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
    Size size = MediaQuery.sizeOf(context);
    List<Options> attendanceOptions = HelperFunction.attendanceOptions();
    return Consumer<MarkAttendanceProvider>(
      builder: (context, value, _) {
        return Card(
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
            leading: SizedBox(
              width: size.width / 8,
              height: size.width / 8,
              child: const Image(
                image: AssetImage('assets/images/profile_avatar.png'),
                fit: BoxFit.cover,
              ),
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

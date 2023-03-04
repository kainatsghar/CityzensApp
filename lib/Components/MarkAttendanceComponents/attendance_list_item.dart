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

  const AttendanceListItem({Key key, this.student, this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Options> attendanceOptions = HelperFunction.attendanceOptions();
    return Consumer<MarkAttendanceProvider>(builder: (context, value, _) {
      return Card(
          child: ListTile(
              leading: SizedBox(
                  width: size.width / 8,
                  height: size.width / 8,
                  child: Image(
                      image: AssetImage('images/profile_avatar.png'),
                      fit: BoxFit.cover)),
              title: Text(
                student.name.toUpperCase(),
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(student.studentId.toString()),
              trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                      !student.status
                          ? attendanceOptions.length - 1
                          : attendanceOptions.length,
                      (i) => Row(children: [
                            CustomToggleButton(
                                student: student,
                                title: attendanceOptions[i].title.characters.first,
                                color: attendanceOptions[i].color,
                                onTap: () => value.changeStatus(
                                    attendanceOptions[i].title.characters.first, index)),
                            Padding(padding: EdgeInsets.only(right: 2.0))
                          ])))));
    });
  }
}

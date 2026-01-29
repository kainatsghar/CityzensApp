import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/components/StudentAttendanceComponents/student_alevel_attendance.dart';
// import 'package:tcs_app/components/StudentAttendanceComponents/student_attendance.dart';
import 'package:tcs_app/provider/StudentAttendance/student_alevel_attendance_provider.dart';
// import 'package:tcs_app/provider/StudentAttendance/student_alevel_attendance_provider.dart';

// import '../../provider/StudentAttendance/student_attendance_provider.dart';

class StudentAttendanceComponent extends StatelessWidget {
  const StudentAttendanceComponent({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: SingleChildScrollView(
        child: Consumer<StudentALevelAttendanceProvider>(
          builder: (context, value, _) {
            return Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: Column(
                children: [
                  Visibility(
                    visible: value.presentDates.isNotEmpty,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: List.generate(
                              value.pieData.length,
                              (index) => Row(
                                children: [
                                  ClipOval(
                                    child: Container(
                                      height: 15,
                                      width: 15,
                                      color: value.pieData[index].color!,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                    ),
                                    child: Text(
                                      value.pieData[index].attendance,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: Container(
                                padding: EdgeInsets.only(
                                  top: size.height * 0.02,
                                ),
                                height: size.height * 0.2,
                                child: PieChart(
                                  PieChartData(sections: value.getSections()),
                                ),
                              ),
                            ),
                            Container(width: size.width * 0.25),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const StudentAttendance(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

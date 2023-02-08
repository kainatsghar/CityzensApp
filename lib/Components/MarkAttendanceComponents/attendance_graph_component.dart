import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomAppButton/custom_app_button.dart';
import 'package:tcs_app/Provider/MarkAttendance/mark_attendance_provider.dart';

class AttendanceGraphComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Consumer<MarkAttendanceProvider>(builder: (context, value, _) {
        return Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
                child: Image.asset('images/icon_success.png',
                    height: size.width / 4, width: size.width / 4),
              ),
              Text('${value.saveAttendanceResponse.message}',
                  style:
                      TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600)),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: size.height * 0.03,
                    horizontal: size.width * 0.05),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Total Students: ${value.students.length}',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: size.width * 0.08),
                  child: Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: List.generate(
                              value.pieData.length,
                              (index) => Row(children: [
                                    ClipOval(
                                      child: Container(
                                          height: 15,
                                          width: 15,
                                          color: value.pieData[index].color),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Text(
                                            value.pieData[index].attendance))
                                  ]))),
                      Container(
                          padding: EdgeInsets.only(top: size.height * 0.05),
                          height: size.height * 0.28,
                          child: PieChart(
                              PieChartData(sections: value.getSections()))),
                      Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: size.height * 0.03),
                          child: CustomAppButton(
                              buttonTitle: 'Edit Attendance',
                              onTap: () => value.reloadStudentList())),
                    ],
                  ))
            ],
          ),
        );
      }),
    );
  }
}

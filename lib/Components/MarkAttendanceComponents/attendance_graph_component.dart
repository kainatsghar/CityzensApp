import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomAppButton/custom_app_button.dart';
import 'package:tcs_app/Provider/MarkAttendance/mark_attendance_provider.dart';

class AttendanceGraphComponent extends StatelessWidget {
  const AttendanceGraphComponent({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Consumer<MarkAttendanceProvider>(builder: (context, value, _) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
                child: Image.asset('images/icon_success.png',
                    height: size.width / 4, width: size.width / 4),
              ),
              Text('${value.saveAttendanceResponse!.message}',
                  style: const TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.w600)),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: size.height * 0.03,
                    horizontal: size.width * 0.05),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Total Students: ${value.students.length}',
                    style: const TextStyle(
                        fontSize: 16.0, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: size.width * 0.07),
                  child: Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: List.generate(
                              value.pieData.length,
                              (index) => SingleChildScrollView(
                                      child: Row(children: [
                                    ClipOval(
                                        child: Container(
                                            height: 12,
                                            width: 12,
                                            color: value.pieData[index].color)),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        child: Text(
                                            value.pieData[index].attendance))
                                  ])))),
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

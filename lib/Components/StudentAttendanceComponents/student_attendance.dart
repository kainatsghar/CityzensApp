import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tcs_app/Provider/StudentAttendance/student_attendance_provider.dart';
import 'package:tcs_app/Utils/app_colors.dart';

class StudentAttendance extends StatelessWidget {
  const StudentAttendance({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentAttendanceProvider>(builder: (context, value, _) {
      return TableCalendar(
          eventLoader: (v) => value.getAttendance(v),
          headerStyle:
              HeaderStyle(formatButtonVisible: false, titleCentered: true),
          focusedDay: value.selectedDate,
          firstDay: DateTime.utc(2022, 01, 01),
          lastDay: DateTime.now(),
          calendarStyle: CalendarStyle(
              isTodayHighlighted: true,
              selectedDecoration: BoxDecoration(
                  color: AppColors.pieChartInvestment.withOpacity(0.4),
                  shape: BoxShape.circle)),
          onPageChanged: (v) => value.reloadAttendance(v),
          selectedDayPredicate: (day) => isSameDay(day, DateTime.now()),
          calendarBuilders: CalendarBuilders(
              singleMarkerBuilder: (context, day, event) => ClipOval(
                    child: SizedBox(
                        height: 12,
                        width: 12,
                        child: ColoredBox(color: event.color)),
                  )),
          startingDayOfWeek: StartingDayOfWeek.monday,
          calendarFormat: CalendarFormat.month);
    });
  }
}

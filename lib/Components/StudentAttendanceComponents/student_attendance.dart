import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tcs_app/provider/StudentAttendance/student_attendance_provider.dart';
import 'package:tcs_app/utils/app_colors.dart';

class StudentAttendance extends StatelessWidget {
  const StudentAttendance({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentAttendanceProvider>(
      builder: (context, value, _) {
        return Card(
          margin: EdgeInsets.zero,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            padding: const EdgeInsets.only(bottom: 8.0),
            decoration: BoxDecoration(
              // color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(16.0),
              gradient: const LinearGradient(
                colors: [AppColors.primaryColor, AppColors.primaryDarkColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: TableCalendar(
              eventLoader: (v) => value.getAttendance(v),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                leftChevronIcon: Icon(
                  Icons.chevron_left,
                  color: AppColors.whiteColor,
                ),
                rightChevronIcon: Icon(
                  Icons.chevron_right,
                  color: AppColors.whiteColor,
                ),
                titleCentered: true,
                titleTextStyle: TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              focusedDay: value.selectedDate,
              firstDay: DateTime.utc(2022, 01, 01),
              lastDay: DateTime.now(),
              daysOfWeekStyle: const DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w600,
                ),
                weekendStyle: TextStyle(
                  color: AppColors.goldenColors,
                  fontWeight: FontWeight.w600,
                ),
              ),
              calendarStyle: const CalendarStyle(
                isTodayHighlighted: true,
                defaultTextStyle: TextStyle(color: AppColors.whiteColor),
                weekendTextStyle: TextStyle(color: AppColors.goldenColors),
                selectedTextStyle: TextStyle(color: AppColors.primaryDarkColor),
                selectedDecoration: BoxDecoration(
                  color: AppColors.secondaryColor,
                  shape: BoxShape.circle,
                ),
              ),
              onPageChanged: (v) => value.reloadAttendance(v),
              selectedDayPredicate: (day) => isSameDay(day, DateTime.now()),
              calendarBuilders: CalendarBuilders(
                singleMarkerBuilder: (context, day, dynamic event) => ClipOval(
                  child: SizedBox(
                    height: 8,
                    width: 8,
                    child: ColoredBox(color: event.color),
                    // child: ColoredBox(color: Colors.grey),
                  ),
                ),
              ),
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarFormat: CalendarFormat.month,
            ),
          ),
        );
      },
    );
  }
}

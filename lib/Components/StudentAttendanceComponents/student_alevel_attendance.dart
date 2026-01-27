import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tcs_app/Provider/StudentAttendance/student_alevel_attendance_provider.dart';
// import 'package:tcs_app/Provider/StudentAttendance/student_attendance_provider.dart';
import 'package:tcs_app/Utils/app_colors.dart';

class StudentAttendance extends StatelessWidget {
  const StudentAttendance({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentALevelAttendanceProvider>(
      builder: (context, value, _) {
        return Container(
          margin: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(15.0),
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
                  height: 12,
                  width: 12,
                  // child: ColoredBox(color: event?.color ?? Colors.grey), // try 1
                  // child: ColoredBox(color: (event as Event?)?.color ?? Colors.grey), //try 2
                  // child: ColoredBox(color: event?.color ?? Color(0xff000000)), // try 3
                  child: ColoredBox(color: event.color), // original
                  // child: ColoredBox(color: Colors.green), // working
                ),
              ),
            ),
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarFormat: CalendarFormat.month,
          ),
        );
      },
    );
  }
}

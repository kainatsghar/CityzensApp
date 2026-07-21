// === UPDATED FILE: student_attendance.dart ===
// Modernized: Premium calendar card with refined gradient, improved border
// radius, shadow, and consistent typography.
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
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [AppColors.primaryColor, AppColors.primaryDarkBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryDarkBlue.withValues(alpha: 0.25),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: TableCalendar(
                eventLoader: (v) => value.getAttendance(v),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  leftChevronIcon: Icon(
                    Icons.chevron_left_rounded,
                    color: AppColors.white,
                    size: 28,
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.white,
                    size: 28,
                  ),
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    color: AppColors.white,
                    fontSize: 17.0,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                  headerPadding: EdgeInsets.symmetric(vertical: 12),
                ),
                focusedDay: value.selectedDate,
                firstDay: DateTime.utc(2022, 01, 01),
                lastDay: DateTime.now(),
                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  weekendStyle: TextStyle(
                    color: AppColors.warningOrange,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                calendarStyle: const CalendarStyle(
                  isTodayHighlighted: true,
                  defaultTextStyle: TextStyle(
                    color: AppColors.white,
                    fontSize: 14,
                  ),
                  weekendTextStyle: TextStyle(
                    color: AppColors.warningOrange,
                    fontSize: 14,
                  ),
                  selectedTextStyle: TextStyle(
                    color: AppColors.primaryDarkBlue,
                    fontWeight: FontWeight.w700,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: AppColors.secondaryColor,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: AppColors.white24,
                    shape: BoxShape.circle,
                  ),
                  todayTextStyle: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                  ),
                  outsideDaysVisible: false,
                ),
                onPageChanged: (v) => value.reloadAttendance(v),
                selectedDayPredicate: (day) => isSameDay(day, DateTime.now()),
                calendarBuilders: CalendarBuilders(
                  singleMarkerBuilder:
                      (context, day, dynamic event) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 0.5),
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: event.color,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: (event.color as Color).withValues(alpha: 0.4),
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                ),
                startingDayOfWeek: StartingDayOfWeek.monday,
                calendarFormat: CalendarFormat.month,
              ),
            ),
          ),
        );
      },
    );
  }
}

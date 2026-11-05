import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tcs_app/citizen/Model/StudentAttendance/student_attendance_response.dart';
import 'package:tcs_app/citizen/Provider/StudentAttendance/student_attendance_provider.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/Utils/app_themes.dart';

class StudentAttendanceComponent extends StatefulWidget {
  const StudentAttendanceComponent({super.key});

  @override
  State<StudentAttendanceComponent> createState() =>
      _StudentAttendanceComponentState();
}

class _StudentAttendanceComponentState
    extends State<StudentAttendanceComponent> {
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentAttendanceProvider>(
      builder: (context, provider, _) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
          child: Column(
            children: [
              // Calendar Card (Color-coded cells + Key legend)
              Container(
                padding: const EdgeInsets.fromLTRB(10, 14, 10, 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.line),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.blue.withValues(alpha: 0.05),
                      offset: const Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TableCalendar(
                      firstDay: DateTime.utc(2020, 1, 1),
                      lastDay: DateTime.now().add(const Duration(days: 365)),
                      focusedDay: provider.selectedDate,
                      currentDay: DateTime.now(),
                      headerVisible: false,
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      calendarFormat: CalendarFormat.month,
                      selectedDayPredicate: (day) =>
                          isSameDay(_selectedDay, day),
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                        });
                      },
                      onPageChanged: (focusedDay) {
                        provider.reloadAttendance(focusedDay);
                      },
                      daysOfWeekStyle: DaysOfWeekStyle(
                        dowTextFormatter: (date, locale) =>
                            DateFormat.E(locale).format(date).substring(0, 3),
                        weekdayStyle: AppThemes.sora(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.muted,
                          letterSpacing: 0.4,
                        ),
                        weekendStyle: AppThemes.sora(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFA0A8B5),
                          letterSpacing: 0.4,
                        ),
                      ),
                      calendarBuilders: CalendarBuilders(
                        defaultBuilder: (context, day, focusedDay) =>
                            _buildDayCell(
                          day,
                          provider,
                          isSelected: isSameDay(day, _selectedDay),
                          isToday: isSameDay(day, DateTime.now()),
                        ),
                        todayBuilder: (context, day, focusedDay) =>
                            _buildDayCell(
                          day,
                          provider,
                          isSelected: isSameDay(day, _selectedDay),
                          isToday: true,
                        ),
                        selectedBuilder: (context, day, focusedDay) =>
                            _buildDayCell(
                          day,
                          provider,
                          isSelected: true,
                          isToday: isSameDay(day, DateTime.now()),
                        ),
                        outsideBuilder: (context, day, focusedDay) =>
                            const SizedBox.shrink(),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Key Legend underneath Calendar
                    Container(
                      padding: const EdgeInsets.only(top: 10, bottom: 2),
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: AppColors.line),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildLegendItem(
                            color: const Color(0xFF0E8A5F),
                            label: 'Present',
                          ),
                          const SizedBox(width: 16),
                          _buildLegendItem(
                            color: const Color(0xFFC42840),
                            label: 'Absent',
                          ),
                          const SizedBox(width: 16),
                          _buildLegendItem(
                            color: const Color(0xFFE0A21A),
                            label: 'Leave',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Day Detail Card underneath for the tapped day
              _buildDayDetailCard(provider),
            ],
          ),
        );
      },
    );
  }

  /// Color-coded Day Cell
  Widget _buildDayCell(
    DateTime day,
    StudentAttendanceProvider provider, {
    bool isSelected = false,
    bool isToday = false,
  }) {
    final Event? event = _findEventForDay(day, provider);
    final bool isWeekend =
        day.weekday == DateTime.saturday || day.weekday == DateTime.sunday;

    Color bgColor = Colors.transparent;
    Color textColor = AppColors.ink;

    if (event != null) {
      if (event.attendance == 'Present') {
        bgColor = const Color(0xFFDDF3EA);
        textColor = const Color(0xFF0E8A5F);
      } else if (event.attendance == 'Absent') {
        bgColor = const Color(0xFFFBE3E7);
        textColor = const Color(0xFFC42840);
      } else if (event.attendance == 'Leave') {
        bgColor = const Color(0xFFFDEFD2);
        textColor = const Color(0xFF8A5A00);
      }
    } else if (isWeekend) {
      textColor = const Color(0xFFA0A8B5);
    } else if (day.isAfter(DateTime.now())) {
      textColor = const Color(0xFFC5CCD7);
    }

    return Center(
      child: Container(
        width: 34,
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(11),
          border: isSelected
              ? Border.all(color: AppColors.blue, width: 2.2)
              : null,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              '${day.day}',
              style: AppThemes.sora(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
            if (isToday)
              Positioned(
                bottom: 2,
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.blue : textColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Day Detail Card
  Widget _buildDayDetailCard(StudentAttendanceProvider provider) {
    final Event? event = _findEventForDay(_selectedDay, provider);
    final bool isWeekend = _selectedDay.weekday == DateTime.saturday ||
        _selectedDay.weekday == DateTime.sunday;

    Color badgeBg = AppColors.blueTint;
    Color badgeColor = AppColors.blue;
    Color chipBg = AppColors.blueTint;
    Color chipColor = AppColors.blue;
    String chipText = 'NO RECORD';
    String subText = 'No attendance recorded';

    if (event != null) {
      if (event.attendance == 'Present') {
        badgeBg = const Color(0xFFDDF3EA);
        badgeColor = const Color(0xFF0E8A5F);
        chipBg = const Color(0xFFDDF3EA);
        chipColor = const Color(0xFF0E8A5F);
        chipText = 'PRESENT';
        subText = 'Full day attendance marked';
      } else if (event.attendance == 'Absent') {
        badgeBg = const Color(0xFFFBE3E7);
        badgeColor = const Color(0xFFC42840);
        chipBg = const Color(0xFFFBE3E7);
        chipColor = const Color(0xFFC42840);
        chipText = 'ABSENT';
        subText = 'Marked absent by school';
      } else if (event.attendance == 'Leave') {
        badgeBg = const Color(0xFFFDEFD2);
        badgeColor = const Color(0xFF8A5A00);
        chipBg = const Color(0xFFFDEFD2);
        chipColor = const Color(0xFF8A5A00);
        chipText = 'LEAVE';
        subText = 'Approved student leave';
      }
    } else if (isWeekend) {
      badgeBg = AppColors.blueTint;
      badgeColor = AppColors.blue;
      chipBg = AppColors.blueTint;
      chipColor = AppColors.muted;
      chipText = 'WEEKEND';
      subText = 'School holiday (Weekend)';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.line),
        boxShadow: [
          BoxShadow(
            color: AppColors.blue.withValues(alpha: 0.04),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          // Day number box
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              '${_selectedDay.day}',
              style: AppThemes.sora(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: badgeColor,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Date and description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('EEEE, d MMMM yyyy').format(_selectedDay),
                  style: AppThemes.sora(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subText,
                  style: AppThemes.roboto(
                    fontSize: 12,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),

          // Chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: chipBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              chipText,
              style: AppThemes.sora(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: chipColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem({required Color color, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2.5),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppThemes.roboto(
            fontSize: 12,
            color: AppColors.muted,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Event? _findEventForDay(
    DateTime day,
    StudentAttendanceProvider provider,
  ) {
    for (final entry in provider.studentAttendance.entries) {
      if (entry.key.year == day.year &&
          entry.key.month == day.month &&
          entry.key.day == day.day) {
        if (entry.value.isNotEmpty) {
          return entry.value.first;
        }
      }
    }
    return null;
  }
}

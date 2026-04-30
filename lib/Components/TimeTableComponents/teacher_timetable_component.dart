// === UPDATED FILE: teacher_timetable_component.dart ===
// Modernized: Premium card-based layout, horizontal scrolling grid,
// today highlighting, break indicator, staggered animations,
// modern notes card, and consistent design system.
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/utils/app_colors.dart';

import '../../custom_widgets/CustomAppButton/custom_app_button.dart';
import '../../custom_widgets/CustomTimeTableFormField/custom_timetable_form_field.dart';
import '../../model/TimeTable/timetable_response.dart';
import '../../provider/TimeTable/timetable_provider.dart';

class TeacherTimeTableComponent extends StatefulWidget {
  const TeacherTimeTableComponent({super.key});

  @override
  State<TeacherTimeTableComponent> createState() =>
      _TeacherTimeTableComponentState();
}

class _TeacherTimeTableComponentState extends State<TeacherTimeTableComponent> {
  final Map<String, List<TextEditingController>> _controllers = {};

  final List<String> weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
  ];
  // Short labels for compact day chips
  final Map<String, String> _dayShortLabels = {
    'Monday': 'MON',
    'Tuesday': 'TUE',
    'Wednesday': 'WED',
    'Thursday': 'THU',
    'Friday': 'FRI',
  };

  // Unique accent color per day for visual distinction
  final Map<String, Color> _dayColors = {
    'Monday': const Color(0xFF5C6BC0),
    'Tuesday': const Color(0xFF26A69A),
    'Wednesday': const Color(0xFFEF5350),
    'Thursday': const Color(0xFFFF7043),
    'Friday': const Color(0xFF42A5F5),
  };

  @override
  void dispose() {
    _controllers.forEach((day, controllers) {
      for (var controller in controllers) {
        controller.dispose();
      }
    });
    super.dispose();
  }

  // ── Business Logic Helper (UNCHANGED) ──
  String getPeriodSubject(PeriodsResponse periods, int index) {
    switch (index) {
      case 0:
        return periods.subject1 ?? '';
      case 1:
        return periods.subject2 ?? '';
      case 2:
        return periods.subject3 ?? '';
      case 3:
        return periods.subject4 ?? '';
      case 4:
        return periods.subject5 ?? '';
      case 5:
        return periods.subject6 ?? '';
      case 6:
        return periods.subject7 ?? '';
      case 7:
        return periods.subject8 ?? '';
      case 8:
        return periods.subject9 ?? '';
      default:
        return '';
    }
  }

  /// Determines today's weekday name for row highlighting
  String _getTodayName() {
    switch (DateTime.now().weekday) {
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TimeTableProvider>(
      builder: (context, value, _) {
        var responseData = value.timeTableResponse;

        var days = responseData?.classTimeTableDTO?.dayLists ?? [];

        if (days.isEmpty) {
          value.isInitial = true;
          days = weekdays
              .map(
                (day) => DayListResponse(
                  dayOfWeek: day,
                  periods: [PeriodsResponse()],
                ),
              )
              .toList();
        }

        for (var day in weekdays) {
          _controllers.putIfAbsent(
            day,
            () => List.generate(9, (_) => TextEditingController()),
          );
        }

        final bool isTeacher =
            value.localDataProvider.userData!.userType == 'Teacher';

        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                // ── Premium Academic Header (Restored & Optimized) ──
                FadeInDown(
                  duration: const Duration(milliseconds: 400),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primaryBlue, Color(0xFF3F51B5)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryBlue.withValues(alpha: 0.25),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.calendar_view_week_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Expanded(
                                    child: Text(
                                      'TIMETABLE',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                        letterSpacing: 2.0,
                                      ),
                                    ),
                                  ),
                                  if (value.sectionController.text.isNotEmpty)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.2,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.white.withValues(
                                            alpha: 0.3,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        value.sectionController.text
                                            .toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'FULL WEEKLY ACADEMIC SCHEDULE',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white.withValues(alpha: 0.8),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // ── Timetable Grid Card (High Density) ──
                FadeInUp(
                  delay: const Duration(milliseconds: 150),
                  duration: const Duration(milliseconds: 400),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.primaryBlue.withValues(alpha: 0.06),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ── Period Number Header ──
                            _buildPeriodHeader(),

                            // ── Day Rows ──
                            ...days.asMap().entries.map((entry) {
                              int dayIndex = entry.key;
                              var dayList = entry.value;
                              var dayName = dayList.dayOfWeek ?? '';
                              var periods = dayList.periods?.isNotEmpty == true
                                  ? dayList.periods![0]
                                  : PeriodsResponse();

                              _controllers.putIfAbsent(
                                dayName,
                                () => List.generate(
                                  9,
                                  (_) => TextEditingController(),
                                ),
                              );

                              final String todayName = _getTodayName();
                              bool isToday = dayName == todayName;

                              return _buildDayRow(
                                dayName: dayName,
                                periods: periods,
                                value: value,
                                isTeacher: isTeacher,
                                isToday: isToday,
                                isLast: dayIndex == days.length - 1,
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ── Notes Section ──
                FadeInUp(
                  delay: const Duration(milliseconds: 300),
                  duration: const Duration(milliseconds: 400),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLightBlue.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.primaryBlue.withValues(alpha: 0.08),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              size: 16,
                              color: AppColors.primaryBlue.withValues(
                                alpha: 0.7,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Important Notes',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryDarkBlue,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _buildNoteItem(
                          'CLASS ASSEMBLY WILL TAKE PLACE EVERY MORNING',
                        ),
                        const SizedBox(height: 6),
                        _buildNoteItem(
                          'BREAK AFTER THE 4TH LESSON UNLESS INFORMED OTHERWISE',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // ── Save Button ──
                if (isTeacher)
                  FadeInUp(
                    delay: const Duration(milliseconds: 400),
                    duration: const Duration(milliseconds: 350),
                    child: CustomAppButton(
                      buttonTitle: 'SAVE',
                      onTap: () => value.saveTimeTable(),
                    ),
                  ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  // ══════════════════════════════════════
  // ── Period Number Header Row ──
  // ══════════════════════════════════════
  Widget _buildPeriodHeader() {
    const double dayColumnWidth = 85;
    const double periodColumnWidth = 100;

    return Container(
      color: AppColors.primaryLightBlue.withValues(alpha: 0.5),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: dayColumnWidth,
            child: Center(
              child: Text(
                'DAY',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryBlue.withValues(alpha: 0.6),
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
          ...List.generate(9, (index) {
            bool isBreakAfter = index == 3;
            return Row(
              children: [
                SizedBox(
                  width: periodColumnWidth,
                  child: Center(
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (isBreakAfter)
                  Container(
                    width: 4,
                    height: 28,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: AppColors.warningOrange.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }

  // ══════════════════════════════════════
  // ── Single Day Row ──
  // ══════════════════════════════════════
  Widget _buildDayRow({
    required String dayName,
    required PeriodsResponse periods,
    required TimeTableProvider value,
    required bool isTeacher,
    required bool isToday,
    required bool isLast,
  }) {
    const double dayColumnWidth = 85;
    const double periodColumnWidth = 100;
    final dayColor = _dayColors[dayName] ?? AppColors.primaryBlue;

    return Container(
      decoration: BoxDecoration(
        color: isToday
            ? AppColors.primaryBlue.withValues(alpha: 0.04)
            : Colors.white,
        border: Border(
          bottom: isLast
              ? BorderSide.none
              : BorderSide(
                  color: Colors.grey.withValues(alpha: 0.08),
                  width: 1,
                ),
          left: isToday
              ? const BorderSide(color: AppColors.primaryBlue, width: 3)
              : BorderSide.none,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: dayColumnWidth,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: dayColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    _dayShortLabels[dayName] ??
                        dayName.substring(0, 3).toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: dayColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
          ...List.generate(9, (index) {
            String periodSubject = getPeriodSubject(periods, index);
            if (_controllers[dayName]![index].text.isEmpty) {
              _controllers[dayName]![index].text = periodSubject;
            }
            bool isBreakAfter = index == 3;

            return Row(
              children: [
                SizedBox(
                  width: periodColumnWidth,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 8,
                    ),
                    child: CustomTimeTableFormField(
                      inputType: TextInputType.text,
                      controller: _controllers[dayName]![index],
                      inputFormatter: [LengthLimitingTextInputFormatter(25)],
                      textCapitalization: TextCapitalization.characters,
                      onChange: (newValue) {
                        value.setValue(dayName, index, newValue);
                      },
                      isEnable: isTeacher,
                    ),
                  ),
                ),
                if (isBreakAfter)
                  Container(
                    width: 4,
                    height: 36,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: AppColors.warningOrange.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }

  // ── Note item with styled bullet ──
  Widget _buildNoteItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 5),
          width: 5,
          height: 5,
          decoration: BoxDecoration(
            color: AppColors.primaryBlue.withValues(alpha: 0.5),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryDarkColor.withValues(alpha: 0.65),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

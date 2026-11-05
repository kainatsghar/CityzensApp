import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/citizen/Model/TimeTable/timetable_response.dart';
import 'package:tcs_app/citizen/Provider/TimeTable/timetable_provider.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/Utils/app_themes.dart';

class TeacherTimeTableComponent extends StatefulWidget {
  const TeacherTimeTableComponent({super.key});

  @override
  State<TeacherTimeTableComponent> createState() =>
      _TeacherTimeTableComponentState();
}

class _TeacherTimeTableComponentState extends State<TeacherTimeTableComponent> {
  final List<String> weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
  ];

  final List<String> shortDays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
  ];

  static const double headerHeight = 40.0;
  static const double rowHeight = 68.0;
  static const double dayColumnWidth = 60.0;
  static const double periodColumnWidth = 88.0;
  static const double sepColumnWidth = 28.0;

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

  Color getSubjectColor(String subject) {
    final s = subject.trim().toLowerCase();
    if (s.isEmpty) return const Color(0xFFDCE1E8);
    if (s.contains('eng')) return const Color(0xFF194F90);
    if (s.contains('math')) return const Color(0xFFE0A21A);
    if (s.contains('urdu')) return const Color(0xFF0E8A5F);
    if (s.contains('sci') || s.contains('phys')) return const Color(0xFFC42840);
    if (s.contains('chem') || s.contains('art')) return const Color(0xFFD9468C);
    if (s.contains('bio')) return const Color(0xFF0E8A5F);
    if (s.contains('isl')) return const Color(0xFF2E7D6B);
    if (s.contains('comp') || s.contains('ict')) return const Color(0xFF5B4BB7);
    if (s.contains('soc') ||
        s.contains('pak') ||
        s.contains('pst') ||
        s.contains('geo') ||
        s.contains('hist')) {
      return const Color(0xFFB5651D);
    }
    if (s.contains('pe') || s.contains('phys')) return const Color(0xFF1E88C7);
    if (s.contains('lib')) return const Color(0xFF6B7487);
    if (s.contains('mus')) return const Color(0xFF8E44AD);
    return const Color(0xFF194F90);
  }

  int get _todayIndex {
    final int weekday = DateTime.now().weekday;
    if (weekday >= 1 && weekday <= 5) {
      return weekday - 1;
    }
    return -1; // Weekend
  }

  void _editSubjectDialog(
    BuildContext context,
    TimeTableProvider provider,
    String dayName,
    int periodIndex,
    String currentSubject,
  ) {
    final TextEditingController controller =
        TextEditingController(text: currentSubject);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          '$dayName - Period ${periodIndex + 1}',
          style: AppThemes.sora(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            hintText: 'Enter subject name',
            hintStyle: AppThemes.roboto(fontSize: 14, color: AppColors.muted),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Cancel',
              style: AppThemes.sora(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.muted,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              provider.setValue(dayName, periodIndex, controller.text.trim());
              Navigator.of(ctx).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.yellow,
              foregroundColor: AppColors.ink,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Save',
              style: AppThemes.sora(fontSize: 13, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TimeTableProvider>(
      builder: (context, provider, _) {
        final bool isTeacher =
            provider.localDataProvider.userData?.userType == 'Teacher';
        final responseData = provider.timeTableResponse;
        List<DayListResponse> days =
            responseData?.classTimeTableDTO?.dayLists ?? [];

        if (days.isEmpty) {
          provider.isInitial = true;
          days = weekdays
              .map(
                (day) => DayListResponse(
                  dayOfWeek: day,
                  periods: [PeriodsResponse()],
                ),
              )
              .toList();
        }

        // Map for quick access: dayName -> PeriodsResponse
        final Map<String, PeriodsResponse> periodsMap = {};
        for (var dayList in days) {
          final String name = dayList.dayOfWeek ?? '';
          if (name.isNotEmpty) {
            periodsMap[name] = (dayList.periods?.isNotEmpty == true)
                ? dayList.periods![0]
                : PeriodsResponse();
          }
        }

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Subheader Row: "This week" + swipe hint
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'This week',
                    style: AppThemes.sora(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Swipe for more periods',
                        style: AppThemes.roboto(
                          fontSize: 12,
                          color: AppColors.muted,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        size: 14,
                        color: AppColors.muted,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Timetable Table Card
              Container(
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
                clipBehavior: Clip.antiAlias,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Pinned Day Column on Left
                    _buildPinnedDayColumn(),

                    // 2. Horizontally Scrolling Timetable
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Assembly Column (spanning all days)
                            _buildSeparatorColumn('ASSEMBLY'),

                            // Periods 1 to 4
                            for (int p = 0; p < 4; p++)
                              _buildPeriodColumn(
                                periodIndex: p,
                                periodsMap: periodsMap,
                                isTeacher: isTeacher,
                                provider: provider,
                              ),

                            // Break Column (spanning all days)
                            _buildSeparatorColumn('BREAK'),

                            // Periods 5 to 9
                            for (int p = 4; p < 9; p++)
                              _buildPeriodColumn(
                                periodIndex: p,
                                periodsMap: periodsMap,
                                isTeacher: isTeacher,
                                provider: provider,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Teacher Save Button (if user is teacher)
              if (isTeacher) ...[
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => provider.saveTimeTable(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.yellow,
                      foregroundColor: AppColors.ink,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Save timetable',
                      style: AppThemes.sora(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  /// Pinned Day Column (Mon to Fri) on Left
  Widget _buildPinnedDayColumn() {
    final int today = _todayIndex;

    return Container(
      width: dayColumnWidth,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: AppColors.line)),
      ),
      child: Column(
        children: [
          // Header "DAY"
          Container(
            height: headerHeight,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.line)),
            ),
            child: Text(
              'DAY',
              style: AppThemes.sora(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.muted,
                letterSpacing: 0.6,
              ),
            ),
          ),

          // 5 Day Rows
          for (int d = 0; d < 5; d++)
            Container(
              height: rowHeight,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: (d == today) ? AppColors.blue : Colors.white,
                border: (d < 4)
                    ? const Border(
                        bottom: BorderSide(color: Color(0xFFEEF1F5)),
                      )
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    shortDays[d],
                    style: AppThemes.sora(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: (d == today) ? Colors.white : AppColors.ink,
                    ),
                  ),
                  if (d == today)
                    Text(
                      'Today',
                      style: AppThemes.sora(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: AppColors.yellow,
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  /// Separator Column (Assembly / Break)
  Widget _buildSeparatorColumn(String label) {
    return Column(
      children: [
        // Top Header
        Container(
          width: sepColumnWidth,
          height: headerHeight,
          decoration: const BoxDecoration(
            color: Color(0xFFFFF3A0),
            border: Border(bottom: BorderSide(color: AppColors.line)),
          ),
        ),

        // Continuous Vertical Separator Body
        Container(
          width: sepColumnWidth,
          height: 5 * rowHeight,
          decoration: const BoxDecoration(
            color: Color(0xFFFFF8C4),
            border: Border(
              right: BorderSide(color: Color(0xFFF3ECC0)),
              left: BorderSide(color: Color(0xFFF3ECC0)),
            ),
          ),
          alignment: Alignment.center,
          child: RotatedBox(
            quarterTurns: 3,
            child: Text(
              label,
              style: AppThemes.sora(
                fontSize: 9,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF6B5900),
                letterSpacing: 2.0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Single Period Column (Header + 5 Day cells)
  Widget _buildPeriodColumn({
    required int periodIndex,
    required Map<String, PeriodsResponse> periodsMap,
    required bool isTeacher,
    required TimeTableProvider provider,
  }) {
    final int today = _todayIndex;

    return SizedBox(
      width: periodColumnWidth,
      child: Column(
        children: [
          // Period Header Badge
          Container(
            height: headerHeight,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.line)),
            ),
            child: Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: AppColors.blueTint,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                '${periodIndex + 1}',
                style: AppThemes.sora(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.blue,
                ),
              ),
            ),
          ),

          // 5 Day Cells for this Period
          for (int d = 0; d < 5; d++)
            _buildPeriodCell(
              dayName: weekdays[d],
              periodIndex: periodIndex,
              periods: periodsMap[weekdays[d]] ?? PeriodsResponse(),
              isToday: (d == today),
              isLastRow: (d == 4),
              isTeacher: isTeacher,
              provider: provider,
            ),
        ],
      ),
    );
  }

  /// Individual Subject Cell
  Widget _buildPeriodCell({
    required String dayName,
    required int periodIndex,
    required PeriodsResponse periods,
    required bool isToday,
    required bool isLastRow,
    required bool isTeacher,
    required TimeTableProvider provider,
  }) {
    final String subject = getPeriodSubject(periods, periodIndex);
    final Color subjectColor = getSubjectColor(subject);
    final bool isEmpty = subject.trim().isEmpty;

    return GestureDetector(
      onTap: isTeacher
          ? () => _editSubjectDialog(
                context,
                provider,
                dayName,
                periodIndex,
                subject,
              )
          : null,
      child: Container(
        height: rowHeight,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
        decoration: BoxDecoration(
          color: isToday ? const Color(0xFFF2F7FD) : Colors.white,
          border: isLastRow
              ? null
              : const Border(
                  bottom: BorderSide(color: Color(0xFFEEF1F5)),
                ),
        ),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(
            color: isEmpty
                ? Colors.white
                : subjectColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
            border: isEmpty
                ? Border.all(color: const Color(0xFFEEF1F5))
                : Border(
                    left: BorderSide(color: subjectColor, width: 3.5),
                  ),
          ),
          alignment: Alignment.center,
          child: Text(
            isEmpty ? '—' : subject,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppThemes.roboto(
              fontSize: 11.5,
              fontWeight: isEmpty ? FontWeight.w400 : FontWeight.w600,
              fontStyle: isEmpty ? FontStyle.italic : FontStyle.normal,
              color: isEmpty ? const Color(0xFFA0A8B5) : AppColors.ink,
              height: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}

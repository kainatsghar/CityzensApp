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
  static const double rowHeight = 72.0;
  static const double dayColumnWidth = 54.0;
  static const double periodColumnWidth = 88.0;
  static const double sepColumnWidth = 26.0;

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
    if (s.contains('isl')) return const Color(0xFF0E8A5F);
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

  String _resolveSubject(
    TimeTableProvider provider,
    String dayName,
    int periodIndex,
    PeriodsResponse periods,
  ) {
    if (provider.isInitial == true) {
      final dynamic edited =
          provider.timetablelistValues[dayName]?[periodIndex + 1];
      if (edited != null) {
        return edited.toString();
      }
    }
    return getPeriodSubject(periods, periodIndex);
  }

  int _countFilledPeriods(
    TimeTableProvider provider,
    Map<String, PeriodsResponse> periodsMap,
  ) {
    int filled = 0;
    for (final String dayName in weekdays) {
      final PeriodsResponse periods = periodsMap[dayName] ?? PeriodsResponse();
      for (int p = 0; p < 9; p++) {
        if (_resolveSubject(provider, dayName, p, periods).trim().isNotEmpty) {
          filled++;
        }
      }
    }
    return filled;
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

        final Widget tableContent = SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(16, 12, 0, isTeacher ? 16 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Subheader Row: title + swipe hint (padding right 16)
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isTeacher ? 'Tap a period to edit' : 'This week',
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
                          isTeacher
                              ? 'Swipe for more'
                              : 'Swipe for more periods',
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
              ),
              const SizedBox(height: 10),

              // Timetable Table Card matching `.tt .scroller` / `.te .scroller`
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(16),
                  ),
                  border: const Border(
                    top: BorderSide(color: AppColors.line),
                    bottom: BorderSide(color: AppColors.line),
                    left: BorderSide(color: AppColors.line),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.blueDeep.withValues(alpha: 0.06),
                      offset: const Offset(0, 1),
                      blurRadius: 3,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(16),
                  ),
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
              ),
            ],
          ),
        );

        if (!isTeacher) {
          return tableContent;
        }

        final int filledCount = _countFilledPeriods(provider, periodsMap);
        return Column(
          children: [
            Expanded(child: tableContent),
            _buildTeacherFooter(filledCount, provider),
          ],
        );
      },
    );
  }

  Widget _buildTeacherFooter(int filledCount, TimeTableProvider provider) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '$filledCount of 45 periods filled',
                  style: AppThemes.roboto(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: AppColors.muted,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.yellow,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFFD9C400),
                      offset: Offset(0, 2),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => provider.saveTimeTable(),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 12.5,
                      ),
                      child: Text(
                        'Save',
                        style: AppThemes.sora(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.blue,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Pinned Day Column (Mon to Fri) on Left matching `.tt .dcol`
  Widget _buildPinnedDayColumn() {
    final int today = _todayIndex;

    return SizedBox(
      width: dayColumnWidth,
      child: Column(
        children: [
          // Header "DAY"
          Container(
            height: headerHeight,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: AppColors.line),
                right: BorderSide(color: AppColors.line),
              ),
            ),
            child: Text(
              'DAY',
              style: AppThemes.sora(
                fontSize: 10,
                fontWeight: FontWeight.w600,
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
                border: Border(
                  right: (d == today)
                      ? BorderSide.none
                      : const BorderSide(color: AppColors.line),
                  bottom: (d < 4 && d != today)
                      ? const BorderSide(color: Color(0xFFEEF1F5))
                      : BorderSide.none,
                ),
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
                  if (d == today) ...[
                    const SizedBox(height: 2),
                    Text(
                      'Today',
                      style: AppThemes.roboto(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.yellow,
                      ),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }

  /// Separator Column (Assembly / Break) matching `.tt .sep`
  Widget _buildSeparatorColumn(String label) {
    final int today = _todayIndex;

    return SizedBox(
      width: sepColumnWidth,
      child: Column(
        children: [
          // Top Header (#FFF3A0)
          Container(
            width: sepColumnWidth,
            height: headerHeight,
            color: const Color(0xFFFFF3A0),
          ),

          // Continuous Vertical Separator Body matching screenshot
          SizedBox(
            width: sepColumnWidth,
            height: 5 * rowHeight,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  children: [
                    for (int d = 0; d < 5; d++)
                      Container(
                        width: sepColumnWidth,
                        height: rowHeight,
                        color: (d == today)
                            ? const Color(0xFFFFF3A0)
                            : const Color(0xFFFFF8C4),
                      ),
                  ],
                ),
                RotatedBox(
                  quarterTurns: 3,
                  child: Text(
                    label,
                    style: AppThemes.sora(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF6B5900),
                      letterSpacing: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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

  /// Individual Subject Cell with curved left accent matching CSS `border-left: 3px solid var(--sc)`
  Widget _buildPeriodCell({
    required String dayName,
    required int periodIndex,
    required PeriodsResponse periods,
    required bool isToday,
    required bool isLastRow,
    required bool isTeacher,
    required TimeTableProvider provider,
  }) {
    final String subject =
        _resolveSubject(provider, dayName, periodIndex, periods);
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
        padding: const EdgeInsets.symmetric(horizontal: 3.5, vertical: 5),
        decoration: BoxDecoration(
          color: isToday ? const Color(0xFFF2F7FD) : Colors.white,
          border: isLastRow
              ? null
              : const Border(
                  bottom: BorderSide(color: Color(0xFFEEF1F5)),
                ),
        ),
        child: isEmpty
            ? (isTeacher
                ? Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: CustomPaint(
                      painter: _DashedRRectPainter(
                        color: const Color(0xFFD5DAE2),
                        radius: 10,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.add_rounded,
                          size: 18,
                          color: Color(0xFFB5BDC9),
                        ),
                      ),
                    ),
                  )
                : Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFEEF1F5)),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '—',
                      style: AppThemes.roboto(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.italic,
                        color: const Color(0xFFA0A8B5),
                      ),
                    ),
                  ))
            : Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: subjectColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  margin: const EdgeInsets.only(left: 3.2),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color.alphaBlend(
                      subjectColor.withValues(alpha: 0.09),
                      Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(8.5),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    subject,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppThemes.roboto(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                      height: 1.2,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class _DashedRRectPainter extends CustomPainter {
  final Color color;
  final double radius;

  const _DashedRRectPainter({
    required this.color,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final RRect rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    ).deflate(0.75);
    final Path path = Path()..addRRect(rrect);
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const double dash = 4.0;
    const double gap = 3.0;
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final double next = (distance + dash).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRRectPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.radius != radius;
}

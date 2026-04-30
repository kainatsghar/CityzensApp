// === UPDATED FILE: student_list_component.dart ===
// Modernized: Premium list layout with sticky bottom button,
// consistent padding, and smooth transitions.
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/components/MarkAttendanceComponents/attendance_graph_component.dart';
import 'package:tcs_app/components/MarkAttendanceComponents/attendance_list_item.dart';
import 'package:tcs_app/custom_widgets/CustomAppButton/custom_app_button.dart';
import 'package:tcs_app/custom_widgets/ShowCustomMessage/show_custom_message.dart';
import 'package:tcs_app/provider/MarkAttendance/mark_attendance_provider.dart';
import 'package:tcs_app/utils/app_colors.dart';
import 'package:tcs_app/utils/app_constants.dart';

class StudentListComponent extends StatelessWidget {
  const StudentListComponent({super.key});

  @override
  Widget build(BuildContext context) {
    // Only rebuild the main layout if weekend, time block, view state, or list length changes
    return Selector<MarkAttendanceProvider, _StudentListState>(
      selector: (context, provider) => _StudentListState(
        isWeekend: provider.isWeekend,
        isTimeLocked: provider.isTimeLocked,
        isViewOnly: provider.isViewOnly,
        isUpdateMode: provider.isUpdateMode,
        isDirty: provider.isDirty,
        isSuccessful: provider.saveAttendanceResponse?.isSuccessful ?? false,
        studentCount: provider.studentListResponse.studentList?.length ?? 0,
        classId: provider.classId,
        sectionName: provider.sectionController.text,
        subjectName: provider.subjectController.text,
        isToday: DateUtils.isSameDay(provider.selectedDate, DateTime.now()),
      ),
      builder: (context, state, _) {
        final value = context.read<MarkAttendanceProvider>();

        if (state.isWeekend) {
          return Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.primaryBlue.withValues(alpha: 0.1),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryBlackText.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.event_busy,
                    size: 64,
                    color: AppColors.primaryBlue.withValues(alpha: 0.7),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Today is a Holiday\n(Saturday/Sunday)",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDarkColor,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Added specific date for clarity
                  Text(
                    DateFormat('EEEE, d MMMM y').format(value.selectedDate),
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.primaryBlue.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "No Attendance is Required",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.softGreyText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final studentList = value.studentListResponse.studentList;
        return (studentList == null || studentList.isEmpty)
            ? const ShowCustomMessage(message: AppConstants.noRecordFound)
            : state.isSuccessful
            ? const AttendanceGraphComponent()
            : Column(
                children: [
                  // ── NEW: Policy Note Banner (Except 19/20, Today only) ──
                  if (state.isToday &&
                      !(state.classId == 19 || state.classId == 20))
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.warningOrange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.warningOrange.withValues(alpha: 0.2),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            size: 14,
                            color: AppColors.warningOrange,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Mark attendance before 10:00 AM today.",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.warningOrange,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // --- Stats / Info Bar ---
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: state.isViewOnly
                          ? AppColors.blueGreyLight
                          : AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: state.isViewOnly
                            ? AppColors.blueGrey.withValues(alpha: 0.2)
                            : AppColors.primaryBlue.withValues(alpha: 0.1),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryBlackText.withValues(
                            alpha: 0.03,
                          ),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today_rounded,
                                      size: 14,
                                      color: AppColors.primaryBlue,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      DateFormat(
                                        'EEEE, d MMMM y',
                                      ).format(value.selectedDate),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: AppColors.primaryDarkColor,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryBlue.withValues(
                                          alpha: 0.08,
                                        ),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        state.sectionName,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.primaryBlue,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    if (state.classId == 19 ||
                                        state.classId == 20) ...[
                                      const SizedBox(width: 6),
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 10,
                                        color: const Color(0xFFBDBDBD),
                                      ),
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.purpleColor
                                              .withValues(alpha: 0.08),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Text(
                                          state.subjectName,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.purpleColor,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                            // Mode Badge
                            _buildCompactPill(
                              state.isViewOnly
                                  ? "View Only"
                                  : state.isTimeLocked
                                  ? "Locked"
                                  : state.isUpdateMode
                                  ? "Update"
                                  : "Today",
                              state.isViewOnly
                                  ? Icons.visibility
                                  : state.isTimeLocked
                                  ? Icons.lock_clock
                                  : state.isUpdateMode
                                  ? Icons.edit_note
                                  : Icons.today,
                              state.isViewOnly
                                  ? AppColors.blueGrey
                                  : state.isTimeLocked
                                  ? AppColors.warningOrange
                                  : AppColors.primaryBlue,
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Divider(
                            height: 1,
                            thickness: 1,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                        // Stats Row
                        Consumer<MarkAttendanceProvider>(
                          builder: (context, prov, _) {
                            final stats = prov.getLiveStatistics();
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildStatItem(
                                  "Present",
                                  stats['Present']!,
                                  AppColors.successGreen,
                                ),
                                _buildStatItem(
                                  "Absent",
                                  stats['Absent']!,
                                  AppColors.errorRed,
                                ),
                                _buildStatItem(
                                  "Leave",
                                  stats['Leave']!,
                                  AppColors.warningOrange,
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  // ── Student List ──
                  // List avoids rebuilds on toggle taps because of Selector above
                  Expanded(
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                      itemCount: studentList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return AttendanceListItem(
                          index: index,
                          student: studentList[index],
                        );
                      },
                    ),
                  ),

                  // ── Sticky Save Button ──
                  if (!state.isViewOnly)
                    SafeArea(
                      top: false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        child: CustomAppButton(
                          buttonTitle: state.isUpdateMode
                              ? 'Update Attendance'
                              : 'Save Attendance',
                          onTap: () {
                            if (state.isTimeLocked ||
                                (state.isUpdateMode && !state.isDirty)) {
                              return;
                            }
                            value.saveAttendance();
                          },
                        ),
                      ),
                    ),
                ],
              );
      },
    );
  }

  Widget _buildStatItem(String label, int count, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "$count",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: AppColors.softGreyText,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildCompactPill(String text, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text.toUpperCase(),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w900,
              fontSize: 9,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _StudentListState {
  final bool isWeekend;
  final bool isTimeLocked;
  final bool isViewOnly;
  final bool isUpdateMode;
  final bool isDirty;
  final bool isSuccessful;
  final int studentCount;
  final int? classId;
  final String sectionName;
  final String subjectName;
  final bool isToday;

  _StudentListState({
    required this.isWeekend,
    required this.isTimeLocked,
    required this.isViewOnly,
    required this.isUpdateMode,
    required this.isDirty,
    required this.isSuccessful,
    required this.studentCount,
    this.classId,
    required this.sectionName,
    required this.subjectName,
    required this.isToday,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _StudentListState &&
          runtimeType == other.runtimeType &&
          isWeekend == other.isWeekend &&
          isTimeLocked == other.isTimeLocked &&
          isViewOnly == other.isViewOnly &&
          isUpdateMode == other.isUpdateMode &&
          isDirty == other.isDirty &&
          isSuccessful == other.isSuccessful &&
          studentCount == other.studentCount &&
          classId == other.classId &&
          sectionName == other.sectionName &&
          subjectName == other.subjectName &&
          isToday == other.isToday;

  @override
  int get hashCode =>
      isWeekend.hashCode ^
      isTimeLocked.hashCode ^
      isViewOnly.hashCode ^
      isUpdateMode.hashCode ^
      isDirty.hashCode ^
      isSuccessful.hashCode ^
      studentCount.hashCode ^
      classId.hashCode ^
      sectionName.hashCode ^
      subjectName.hashCode ^
      isToday.hashCode;
}

// === UPDATED FILE: student_alevel_attendance_component.dart ===
// Modernized: Premium statistics card, refined legend chips, smooth animations
import 'package:animate_do/animate_do.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/components/StudentAttendanceComponents/student_alevel_attendance.dart';
import 'package:tcs_app/provider/StudentAttendance/student_alevel_attendance_provider.dart';
import 'package:tcs_app/utils/app_colors.dart';

class StudentAttendanceComponent extends StatelessWidget {
  const StudentAttendanceComponent({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Consumer<StudentALevelAttendanceProvider>(
          builder: (context, value, _) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  // ── Subjects List ──
                  if (value.subjects.isNotEmpty)
                    FadeInDown(
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        height: 50,
                        margin: const EdgeInsets.only(bottom: 20),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: value.subjects.length,
                          itemBuilder: (context, index) {
                            final subject = value.subjects[index];
                            final isSelected =
                                subject.subjectId == value.selectedSubjectId;
                            return GestureDetector(
                              onTap: () {
                                if (!isSelected) {
                                  value.setSelectedSubject(subject.subjectId!);
                                }
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.only(right: 12),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primaryBlue
                                      : AppColors.white,
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primaryBlue
                                        : AppColors.primaryBlue.withValues(
                                            alpha: 0.15,
                                          ),
                                    width: 1.5,
                                  ),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: AppColors.primaryBlue
                                                .withValues(alpha: 0.3),
                                            blurRadius: 8,
                                            offset: const Offset(0, 3),
                                          ),
                                        ]
                                      : [],
                                ),
                                child: Center(
                                  child: Text(
                                    subject.subjectName ?? '',
                                    style: TextStyle(
                                      color: isSelected
                                          ? AppColors.white
                                          : AppColors.primaryDarkBlue,
                                      fontWeight: isSelected
                                          ? FontWeight.w800
                                          : FontWeight.w600,
                                      fontSize: 14,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                  // ── Calendar ──
                  FadeInUp(
                    delay: const Duration(milliseconds: 200),
                    duration: const Duration(milliseconds: 400),
                    child: const StudentAttendance(),
                  ),

                  const SizedBox(height: 24),

                  // ── Statistics Card ──
                  Visibility(
                    visible: value.presentDates.isNotEmpty,
                    child: FadeInDown(
                      duration: const Duration(milliseconds: 400),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.primaryBlue.withValues(alpha: 0.08),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.black.withValues(alpha: 0.03),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Section title
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryBlue.withValues(
                                      alpha: 0.08,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.pie_chart_rounded,
                                    color: AppColors.primaryBlue,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Monthly Summary',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primaryDarkBlue,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // ── Legend Chips ──
                            Wrap(
                              spacing: 12,
                              runSpacing: 8,
                              children: List.generate(
                                value.pieData.length,
                                (index) => _buildLegendChip(
                                  label: value.pieData[index].attendance,
                                  color: value.pieData[index].color!,
                                  count: value.pieData[index].attendanceCount,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),

                            // ── Pie Chart ──
                            SizedBox(
                              height: size.height * 0.18,
                              child: PieChart(
                                PieChartData(
                                  sections: value.getSections(),
                                  sectionsSpace: 3,
                                  centerSpaceRadius: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLegendChip({
    required String label,
    required Color color,
    required int count,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            '$label ($count)',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}

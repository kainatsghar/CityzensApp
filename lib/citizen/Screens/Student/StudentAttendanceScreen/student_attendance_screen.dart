import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/citizen/Components/StudentAttendanceComponents/student_attendance_component.dart';
import 'package:tcs_app/CustomWidgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/CustomWidgets/ShowError/show_error.dart';
import 'package:tcs_app/citizen/Provider/StudentAttendance/student_attendance_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/Utils/app_themes.dart';
import 'package:tcs_app/CustomWidgets/CustomAppBar/cityzens_back_button.dart';

class StudentAttendanceScreen extends StatefulWidget {
  const StudentAttendanceScreen({super.key});

  @override
  State<StudentAttendanceScreen> createState() =>
      _StudentAttendanceScreenState();
}

class _StudentAttendanceScreenState extends State<StudentAttendanceScreen> {
  late Future attendanceData;

  StudentAttendanceProvider get attendanceProvider =>
      Provider.of<StudentAttendanceProvider>(
        AppNavigation.currentContext!,
        listen: false,
      );

  @override
  void initState() {
    attendanceData = attendanceProvider.loadAttendance();
    super.initState();
  }

  @override
  void dispose() {
    attendanceProvider.clearDate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentAttendanceProvider>(
      builder: (context, provider, _) {
        final String monthYear =
            DateFormat('MMMM yyyy').format(provider.selectedDate);

        return Scaffold(
          backgroundColor: AppColors.paper,
          body: Column(
            children: [
              // S4 Blue Top Header (Title, Month switcher, 3 Summary Badges)
              Container(
                width: double.infinity,
                color: AppColors.blue,
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
                    child: Column(
                      children: [
                        // App Bar Row (Circular Back Button, Centered Title, Spacer)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CityzensBackButton(
                              size: 40,
                              onTap: () => Navigator.of(context).maybePop(),
                            ),
                            Text(
                              'Attendance',
                              style: AppThemes.sora(
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 40, height: 40),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Month Switcher Row (< Month Year >)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                final prev = DateTime(
                                  provider.selectedDate.year,
                                  provider.selectedDate.month - 1,
                                  1,
                                );
                                provider.reloadAttendance(prev);
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.13),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.chevron_left_rounded,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                            Text(
                              monthYear,
                              style: AppThemes.sora(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                final next = DateTime(
                                  provider.selectedDate.year,
                                  provider.selectedDate.month + 1,
                                  1,
                                );
                                provider.reloadAttendance(next);
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.13),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.chevron_right_rounded,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // 3 Summary Stat Badges (Present, Absent, Leave)
                        Row(
                          children: [
                            Expanded(
                              child: _buildSummaryBadge(
                                count: provider.presentDates.length,
                                label: 'Present',
                                color: const Color(0xFF4CD39B),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: _buildSummaryBadge(
                                count: provider.absentDates.length,
                                label: 'Absent',
                                color: const Color(0xFFFF7A90),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: _buildSummaryBadge(
                                count: provider.leaveDates.length,
                                label: 'Leave',
                                color: const Color(0xFFFFC94D),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Attendance Calendar & Day Detail
              Expanded(
                child: FutureBuilder(
                  future: attendanceData,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Center(child: CustomLoader());
                      default:
                        if (snapshot.hasData) {
                          return const StudentAttendanceComponent();
                        } else {
                          return ShowError(errorText: '${snapshot.error}');
                        }
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryBadge({
    required int count,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$count',
            style: AppThemes.sora(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                label,
                style: AppThemes.roboto(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.85),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

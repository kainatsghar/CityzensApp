// === UPDATED FILE: teacher_timetable_screen.dart ===
// Modernized: Premium skeleton loader, consistent background
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/TimeTableComponents/teacher_timetable_component.dart';
import '../../../custom_widgets/CustomAppBar/custom_app_bar.dart';
import '../../../custom_widgets/ShowError/show_error.dart';
import '../../../provider/TimeTable/timetable_provider.dart';
import '../../../routes/app_navigation.dart';
import '../../../utils/app_colors.dart';

class TeacherTimeTableScreen extends StatefulWidget {
  const TeacherTimeTableScreen({super.key});

  @override
  State<TeacherTimeTableScreen> createState() => _TeacherTimeTableScreenState();
}

class _TeacherTimeTableScreenState extends State<TeacherTimeTableScreen> {
  late Future timetableRecords;
  var provider = Provider.of<TimeTableProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  @override
  void initState() {
    timetableRecords = provider.loadTimeTable();
    super.initState();
  }

  @override
  void dispose() {
    provider.clearData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'TIMETABLE'),
      backgroundColor: Colors.grey.shade50,
      body: FutureBuilder(
        future: timetableRecords,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return _buildSkeletonLoader();
            default:
              if (snapshot.hasData) {
                return const TeacherTimeTableComponent();
              } else {
                //return const TeacherTimeTableComponent();
                return ShowError(errorText: '${snapshot.error}');
              }
          }
        },
      ),
    );
  }

  /// Premium shimmer-style skeleton while timetable loads
  Widget _buildSkeletonLoader() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // ── Header skeleton ──
          Container(
            width: double.infinity,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.grey.shade200,
                  Colors.grey.shade100,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          const SizedBox(height: 20),
          // ── Grid skeleton ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: Column(
              children: [
                // Period header skeleton
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        height: 24,
                        decoration: BoxDecoration(
                          color: AppColors.primaryLightBlue.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Day rows skeleton
                ...List.generate(5, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 56,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ...List.generate(
                          5,
                          (i) => Expanded(
                            child: Container(
                              height: 36,
                              margin: const EdgeInsets.only(left: 4),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border:
                                    Border.all(color: Colors.grey.shade100),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // ── Notes skeleton ──
          Container(
            width: double.infinity,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primaryLightBlue.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ],
      ),
    );
  }
}

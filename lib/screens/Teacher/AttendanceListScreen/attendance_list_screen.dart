// === UPDATED FILE: attendance_list_screen.dart ===
// Modernized: Consistent background, premium AppBar
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/components/MarkAttendanceComponents/student_list_component.dart';
import 'package:tcs_app/custom_widgets/CustomAppBar/custom_app_bar.dart';
import 'package:tcs_app/custom_widgets/ShowError/show_error.dart';
import 'package:tcs_app/provider/MarkAttendance/mark_attendance_provider.dart';
import 'package:tcs_app/routes/app_navigation.dart';

import 'dart:async';
import 'package:tcs_app/utils/app_colors.dart';

class AttendanceListScreen extends StatefulWidget {
  const AttendanceListScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return AttendanceListScreenState();
  }
}

class AttendanceListScreenState extends State<AttendanceListScreen> {
  late Future _studentListService;

  var provider = Provider.of<MarkAttendanceProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  @override
  void initState() {
    _studentListService = provider.loadStudentList();
    super.initState();
  }

  @override
  void dispose() {
    provider.clearAttendanceData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'MARK ATTENDANCE'),
      backgroundColor: AppColors.grey50,
      body: FutureBuilder(
        future: _studentListService,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: 8,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.grey500.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: AppColors.grey500.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 12,
                                width: 120,
                                color: AppColors.grey500.withValues(alpha: 0.2),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: 10,
                                width: 80,
                                color: AppColors.grey500.withValues(alpha: 0.2),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: List.generate(
                            3,
                            (i) => Container(
                              margin: const EdgeInsets.only(left: 5),
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.grey500.withValues(alpha: 0.2),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            default:
              if (snapshot.hasData) {
                return const StudentListComponent();
              } else {
                return ShowError(errorText: '${snapshot.error}');
              }
          }
        },
      ),
    );
  }
}

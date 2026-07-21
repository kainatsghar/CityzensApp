// === UPDATED FILE: student_alevel_attendance_screen.dart ===
// Modernized: Consistent background with rest of app
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/components/StudentAttendanceComponents/student_alevel_attendance_component.dart';
import 'package:tcs_app/custom_widgets/CustomAppBar/custom_app_bar.dart';
import 'package:tcs_app/custom_widgets/ShowError/show_error.dart';
import 'package:tcs_app/provider/StudentAttendance/student_alevel_attendance_provider.dart';
import 'package:tcs_app/routes/app_navigation.dart';
import 'package:tcs_app/custom_widgets/ShimmerEffect/attendance_shimmer.dart';
import 'package:tcs_app/utils/app_colors.dart';

class StudentAlevelAttendanceScreen extends StatefulWidget {
  const StudentAlevelAttendanceScreen({super.key});

  @override
  State<StudentAlevelAttendanceScreen> createState() =>
      _StudentAlevelAttendanceScreenState();
}

class _StudentAlevelAttendanceScreenState
    extends State<StudentAlevelAttendanceScreen> {
  late Future attendanceData;
  var attendanceProvider = Provider.of<StudentALevelAttendanceProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  @override
  void initState() {
    attendanceData = attendanceProvider.loadInitialData();
    super.initState();
  }

  @override
  void dispose() {
    attendanceProvider.clearDate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "ATTENDANCE"),
      backgroundColor: AppColors.grey50,
      body: FutureBuilder(
        future: attendanceData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const AttendanceShimmer();
          } else if (snapshot.hasError) {
            return ShowError(errorText: '${snapshot.error}');
          } else {
            return const StudentAttendanceComponent();
          }
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/components/StudentAttendanceComponents/student_alevel_attendance_component.dart';
// import 'package:tcs_app/components/StudentAttendanceComponents/student_attendance_component.dart';
import 'package:tcs_app/custom_widgets/CustomAppBar/custom_app_bar.dart';
import 'package:tcs_app/custom_widgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/custom_widgets/ShowError/show_error.dart';
import 'package:tcs_app/provider/StudentAttendance/student_alevel_attendance_provider.dart';
import 'package:tcs_app/routes/app_navigation.dart';

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
    return Scaffold(
      appBar: const CustomAppBar(title: "ATTENDANCE"),
      body: FutureBuilder(
        future: attendanceData,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const CustomLoader();
            default:
              if (snapshot.hasData) {
                return const StudentAttendanceComponent();
              } else {
                return ShowError(errorText: '${snapshot.error}');
              }
          }
        },
      ),
    );
  }
}

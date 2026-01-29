import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/StudentAttendanceComponents/student_attendance_component.dart';
import '../../../custom_widgets/CustomAppBar/custom_app_bar.dart';
import '../../../custom_widgets/CustomLoader/custom_loader.dart';
import '../../../custom_widgets/ShowError/show_error.dart';
import '../../../provider/StudentAttendance/student_attendance_provider.dart';
import '../../../routes/app_navigation.dart';

class StudentAttendanceScreen extends StatefulWidget {
  const StudentAttendanceScreen({super.key});

  @override
  State<StudentAttendanceScreen> createState() =>
      _StudentAttendanceScreenState();
}

class _StudentAttendanceScreenState extends State<StudentAttendanceScreen> {
  late Future attendanceData;
  var attendanceProvider = Provider.of<StudentAttendanceProvider>(
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

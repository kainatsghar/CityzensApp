import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Components/StudentAttendanceComponents/student_alevel_attendance_subject_component.dart';
import 'package:tcs_app/CustomWidgets/CustomAppBar/custom_app_bar.dart';
import 'package:tcs_app/CustomWidgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/CustomWidgets/ShowError/show_error.dart';
import 'package:tcs_app/Provider/StudentAttendance/student_alevel_attendance_provider.dart';
// import 'package:tcs_app/Provider/StudentAttendance/student_attendance_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';

class StudentALevelAttendanceSubjectScreen extends StatefulWidget {
  const StudentALevelAttendanceSubjectScreen({super.key});

  @override
  State<StudentALevelAttendanceSubjectScreen> createState() =>
      _StudentALevelAttendanceSubjectScreenState();
}

class _StudentALevelAttendanceSubjectScreenState
    extends State<StudentALevelAttendanceSubjectScreen> {
  late Future _attendanceSubjectsService;
  var provider = Provider.of<StudentALevelAttendanceProvider>(
      AppNavigation.currentContext!,
      listen: false);

  @override
  void initState() {
    _attendanceSubjectsService = provider.loadAttendanceSubjects();
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
        appBar: const CustomAppBar(title: 'Attendance Subject'),
        body: RefreshIndicator(
            child: FutureBuilder(
                future: _attendanceSubjectsService,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const CustomLoader();
                    default:
                      if (snapshot.hasData) {
                        return const StudentALevelAttendanceSubjectComponent();
                      } else {
                        return ShowError(errorText: '${snapshot.error}');
                      }
                  }
                }),
            onRefresh: () => provider.loadAttendanceSubjects()));
  }
}

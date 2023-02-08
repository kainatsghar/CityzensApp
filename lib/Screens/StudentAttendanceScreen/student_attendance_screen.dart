import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomAppbar/custom_appbar.dart';
import 'package:tcs_app/Provider/StudentAttendance/student_attendance_provider.dart';

import '../../Components/StudentAttendanceComponents/student_attendance_component.dart';
import '../../CustomWidgets/CustomLoader/custom_loader.dart';
import '../../CustomWidgets/ShowError/show_error.dart';
import '../../Provider/Library/library_provider.dart';
import '../../Routes/app_navigation.dart';

class StudentAttendanceScreen extends StatefulWidget {
  const StudentAttendanceScreen({Key key}) : super(key: key);

  @override
  State<StudentAttendanceScreen> createState() =>
      _StudentAttendanceScreenState();
}

class _StudentAttendanceScreenState extends State<StudentAttendanceScreen> {
  Future studentInfo, attendanceData;
  var provider =
      Provider.of<LibraryProvider>(AppNavigation.currentContext, listen: false);
  var attendanceProvider = Provider.of<StudentAttendanceProvider>(
      AppNavigation.currentContext,
      listen: false);

  @override
  void initState() {
    studentInfo = provider.loadLibraryRecords();
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
        appBar: CustomAppBar(title: "Attendance"),
        body: RefreshIndicator(
            child: FutureBuilder(
                future: Future.wait([studentInfo, attendanceData]),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const CustomLoader();
                    default:
                      if (snapshot.hasData) {
                        return StudentAttendanceComponent();
                      } else {
                        return ShowError(errorText: '${snapshot.error}');
                      }
                  }
                }),
            onRefresh: () => provider.loadLibraryRecords()));
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/components/MarkAttendanceComponents/student_list_component.dart';
import 'package:tcs_app/custom_widgets/CustomAppBar/custom_app_bar.dart';
import 'package:tcs_app/custom_widgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/custom_widgets/ShowError/show_error.dart';
import 'package:tcs_app/provider/MarkAttendance/mark_attendance_provider.dart';
import 'package:tcs_app/routes/app_navigation.dart';

import 'dart:async';

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
      body: FutureBuilder(
        future: _studentListService,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const CustomLoader();
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

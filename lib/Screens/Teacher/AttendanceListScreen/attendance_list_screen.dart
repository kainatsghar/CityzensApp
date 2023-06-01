import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Components/MarkAttendanceComponents/student_list_component.dart';
import 'package:tcs_app/CustomWidgets/CustomAppbar/custom_appbar.dart';
import 'package:tcs_app/CustomWidgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/CustomWidgets/ShowError/show_error.dart';
import 'package:tcs_app/Provider/MarkAttendance/mark_attendance_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';

import 'dart:async';

class AttendanceListScreen extends StatefulWidget {
  AttendanceListScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AttendanceListScreenState();
  }
}

class AttendanceListScreenState extends State<AttendanceListScreen> {
  Future _studentListService;

  var provider = Provider.of<MarkAttendanceProvider>(
      AppNavigation.currentContext,
      listen: false);

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
        appBar: CustomAppBar(title: 'MARK ATTENDANCE'),
        body: FutureBuilder(
            future: _studentListService,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const CustomLoader();
                default:
                  if (snapshot.hasData) {
                    return StudentListComponent();
                  } else {
                    return ShowError(errorText: '${snapshot.error}');
                  }
              }
            }));
  }
}

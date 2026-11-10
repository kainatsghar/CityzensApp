import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/citizen/Components/MarkAttendanceComponents/mark_attendance_header.dart';
import 'package:tcs_app/citizen/Components/MarkAttendanceComponents/student_list_component.dart';
import 'package:tcs_app/CustomWidgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/CustomWidgets/ShowError/show_error.dart';
import 'package:tcs_app/citizen/Provider/MarkAttendance/mark_attendance_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Utils/app_colors.dart';

class AttendanceListScreen extends StatefulWidget {
  const AttendanceListScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return AttendanceListScreenState();
  }
}

class AttendanceListScreenState extends State<AttendanceListScreen> {
  late Future _studentListService;

  MarkAttendanceProvider get provider => Provider.of<MarkAttendanceProvider>(
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
      backgroundColor: AppColors.paper,
      body: Column(
        children: [
          // T2 Blue Header with Circular Back Button & Class Picker
          const MarkAttendanceHeader(),

          Expanded(
            child: FutureBuilder(
              future: _studentListService,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(child: CustomLoader());
                  default:
                    if (snapshot.hasData) {
                      return const StudentListComponent();
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
  }
}

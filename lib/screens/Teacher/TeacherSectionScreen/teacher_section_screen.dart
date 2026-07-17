import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/components/MarkAttendanceComponents/teacher_section_component.dart';
import 'package:tcs_app/custom_widgets/CustomAppBar/custom_app_bar.dart';
import 'package:tcs_app/custom_widgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/custom_widgets/ShowError/show_error.dart';
import 'package:tcs_app/provider/Dashboard/dashboard_provider.dart';
import 'package:tcs_app/provider/MarkAttendance/mark_attendance_provider.dart';
import 'package:tcs_app/routes/app_navigation.dart';

class TeacherSectionScreen extends StatefulWidget {
  const TeacherSectionScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return TeacherSectionScreenState();
  }
}

class TeacherSectionScreenState extends State<TeacherSectionScreen> {
  late Future _sections;
  var provider = Provider.of<MarkAttendanceProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  var dashboardProvider = Provider.of<DashboardProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  @override
  void initState() {
    if (!dashboardProvider.isDashboardDataInitialized &&
        !dashboardProvider.isDashboardDataLoading) {
      _sections = dashboardProvider.initializeDashboardDataForTeacher();
      // _sections = provider.loadSections();
    }
    super.initState();
  }

  @override
  void dispose() {
    provider.clearClassSectionData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'ATTENDANCE'),
      body:
          (dashboardProvider.getSectionsWithDiary(false) != null &&
              dashboardProvider.getSectionsWithDiary(false)!.isNotEmpty)
          ? TeacherSectionComponent()
          : FutureBuilder(
              future: _sections,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const CustomLoader();
                  default:
                    if (snapshot.hasData) {
                      return const TeacherSectionComponent();
                    } else {
                      return ShowError(errorText: '${snapshot.error}');
                    }
                }
              },
            ),
    );
  }
}

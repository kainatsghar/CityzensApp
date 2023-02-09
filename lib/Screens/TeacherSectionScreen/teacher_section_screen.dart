import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Components/MarkAttendanceComponents/teacher_section_component.dart';
import 'package:tcs_app/CustomWidgets/CustomAppbar/custom_appbar.dart';
import 'package:tcs_app/CustomWidgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/CustomWidgets/ShowError/show_error.dart';
import 'package:tcs_app/Provider/MarkAttendance/mark_attendance_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';

class TeacherSectionScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TeacherSectionScreenState();
  }
}

class TeacherSectionScreenState extends State<TeacherSectionScreen> {
  Future _sections;
  var provider = Provider.of<MarkAttendanceProvider>(
      AppNavigation.currentContext,
      listen: false);

  @override
  void initState() {
    _sections = provider.loadSections();
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
        appBar: CustomAppBar(title: 'Attendance'),
        body: RefreshIndicator(
            child: FutureBuilder(
                future: _sections,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const CustomLoader();
                    default:
                      if (snapshot.hasData) {
                        return TeacherSectionComponent();
                      } else {
                        return ShowError(errorText: '${snapshot.error}');
                      }
                  }
                }),
            onRefresh: () => provider.loadSections()));
  }
}

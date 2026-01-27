import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/CustomAppBar/custom_app_bar.dart';
import 'package:tcs_app/custom_widgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/custom_widgets/ShowError/show_error.dart';
import 'package:tcs_app/Provider/TimeTable/timetable_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';

import '../../../Components/TimeTableComponents/teacher_timeTable_section_component.dart';

class TeacherTimeTableSectionScreen extends StatefulWidget {
  const TeacherTimeTableSectionScreen({super.key});

  @override
  State<TeacherTimeTableSectionScreen> createState() {
    return _TeacherTimeTableSectionScreenState();
  }
}

class _TeacherTimeTableSectionScreenState
    extends State<TeacherTimeTableSectionScreen> {
  late Future _sections;
  var provider = Provider.of<TimeTableProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

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
      appBar: const CustomAppBar(title: 'TIMETABLE'),
      body: RefreshIndicator(
        child: FutureBuilder(
          future: _sections,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const CustomLoader();
              default:
                if (snapshot.hasData) {
                  return const TeacherTimeTableSectionComponent();
                } else {
                  return ShowError(errorText: '${snapshot.error}');
                }
            }
          },
        ),
        onRefresh: () => provider.loadSections(),
      ),
    );
  }
}

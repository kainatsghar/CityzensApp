import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Components/SchoolEventsComponents/school_events_component.dart';
import 'package:tcs_app/Provider/SchoolEvents/school_event_provider.dart';

import '../../../CustomWidgets/CustomAppBar/custom_app_bar.dart';
import '../../../CustomWidgets/CustomLoader/custom_loader.dart';
import '../../../CustomWidgets/ShowError/show_error.dart';
import '../../../Routes/app_navigation.dart';
import '../../../Routes/app_navigation_routes.dart';
import '../../../Utils/app_colors.dart';

class TeacherSchoolEventScreen extends StatefulWidget {
  const TeacherSchoolEventScreen({super.key});

  @override
  State<TeacherSchoolEventScreen> createState() =>
      _TeacherSchoolEventScreenState();
}

class _TeacherSchoolEventScreenState extends State<TeacherSchoolEventScreen> {
  late Future eventRecords;
  var provider = Provider.of<SchoolEventProvider>(AppNavigation.currentContext!,
      listen: false);

  @override
  void initState() {
    eventRecords = provider.loadEvents();
    super.initState();
  }

  @override
  void dispose() {
    provider.clearLibraryData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'SCHOOL EVENTS'),
      body: FutureBuilder(
          future: eventRecords,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const CustomLoader();
              default:
                if (snapshot.hasData) {
                  return const SchoolEventsComponent();
                } else {
                  return ShowError(errorText: '${snapshot.error}');
                }
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            AppNavigation.navigateTo(AppNavRoutes.addSchoolEventRoute),
        backgroundColor: AppColors.primaryColor,
        child: const Icon(
          Icons.add,
          color: AppColors.whiteColor,
        ),
      ),
    );
  }
}

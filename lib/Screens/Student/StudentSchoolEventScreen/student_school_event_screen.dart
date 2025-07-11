import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Components/SchoolEventsComponents/school_events_component.dart';
import 'package:tcs_app/Provider/SchoolEvents/school_event_provider.dart';

import '../../../CustomWidgets/CustomAppBar/custom_app_bar.dart';
import '../../../CustomWidgets/CustomLoader/custom_loader.dart';
import '../../../CustomWidgets/ShowError/show_error.dart';
import '../../../Routes/app_navigation.dart';

class StudentSchoolEventScreen extends StatefulWidget {
  const StudentSchoolEventScreen({super.key});

  @override
  State<StudentSchoolEventScreen> createState() =>
      _StudentSchoolEventScreenState();
}

class _StudentSchoolEventScreenState extends State<StudentSchoolEventScreen> {
  late Future schoolEvents;
  var provider = Provider.of<SchoolEventProvider>(AppNavigation.currentContext!,
      listen: false);

  @override
  void initState() {
    schoolEvents = provider.loadEvents();
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
          future: schoolEvents,
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
    );
  }
}

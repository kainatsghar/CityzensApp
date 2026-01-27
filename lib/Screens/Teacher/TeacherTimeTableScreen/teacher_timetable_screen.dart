import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/TimeTableComponents/teacher_timetable_component.dart';
import '../../../custom_widgets/CustomAppBar/custom_app_bar.dart';
import '../../../custom_widgets/CustomLoader/custom_loader.dart';
import '../../../custom_widgets/ShowError/show_error.dart';
import '../../../Provider/TimeTable/timetable_provider.dart';
import '../../../Routes/app_navigation.dart';

class TeacherTimeTableScreen extends StatefulWidget {
  const TeacherTimeTableScreen({super.key});

  @override
  State<TeacherTimeTableScreen> createState() => _TeacherTimeTableScreenState();
}

class _TeacherTimeTableScreenState extends State<TeacherTimeTableScreen> {
  late Future timetableRecords;
  var provider = Provider.of<TimeTableProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  @override
  void initState() {
    timetableRecords = provider.loadTimeTable();

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
      appBar: const CustomAppBar(title: 'TIMETABLE'),
      body: FutureBuilder(
        future: timetableRecords,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const CustomLoader();
            default:
              if (snapshot.hasData) {
                return const TeacherTimeTableComponent();
              } else {
                //return const TeacherTimeTableComponent();
                return ShowError(errorText: '${snapshot.error}');
              }
          }
        },
      ),
    );
  }
}

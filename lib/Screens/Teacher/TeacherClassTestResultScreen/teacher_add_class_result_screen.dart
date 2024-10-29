import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Components/ClassTestResultComponents/test_result_component.dart';
import 'package:tcs_app/CustomWidgets/CustomAppbar/custom_appbar.dart';

import '../../../CustomWidgets/CustomLoader/custom_loader.dart';
import '../../../CustomWidgets/ShowError/show_error.dart';
import '../../../Provider/ClassTestResult/class_test_result_provider.dart';
import '../../../Routes/app_navigation.dart';

class TeacherAddClassResultScreen extends StatefulWidget {
  const TeacherAddClassResultScreen({super.key});

  @override
  State<TeacherAddClassResultScreen> createState() =>
      _TeacherAddClassResultScreenState();
}

class _TeacherAddClassResultScreenState
    extends State<TeacherAddClassResultScreen>
    with SingleTickerProviderStateMixin {
  var provider = Provider.of<ClassTestResultProvider>(
      AppNavigation.currentContext!,
      listen: false);

  @override
  void initState() {
    provider.initializeData(this);
    studentRecords = provider.loadStudentsBySubject();

    super.initState();
  }

  late Future studentRecords;
  late Future studentRecordsWithMarks;

  @override
  void dispose() {
    provider.clearLibraryData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'CLASS TEST RESULTS'),
      body: FutureBuilder(
          future: studentRecords,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const CustomLoader();
              default:
                if (snapshot.hasData) {
                  return const SingleChildScrollView(
                    child: Column(
                      children: [
                        TestResultComponent(),
                      ],
                    ),
                  );
                } else {
                  return ShowError(errorText: '${snapshot.error}');
                }
            }
          }),
    );
  }
}

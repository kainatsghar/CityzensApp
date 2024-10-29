import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Components/ClassTestResultComponents/student_class_test_result_component.dart';
import 'package:tcs_app/Provider/ClassTestResult/class_test_result_provider.dart';

import '../../../CustomWidgets/CustomAppbar/custom_appbar.dart';
import '../../../CustomWidgets/CustomLoader/custom_loader.dart';
import '../../../CustomWidgets/ShowError/show_error.dart';
import '../../../Routes/app_navigation.dart';

class StudentClassResultScreen extends StatefulWidget {
  const StudentClassResultScreen({super.key});

  @override
  State<StudentClassResultScreen> createState() =>
      _StudentClassResultScreenState();
}

class _StudentClassResultScreenState extends State<StudentClassResultScreen> {
  late Future studentMarksRecords;
  var provider = Provider.of<ClassTestResultProvider>(
      AppNavigation.currentContext!,
      listen: false);

  @override
  void initState() {
    studentMarksRecords = provider.loadStudentsTestResultswithMarks();
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
      appBar: const CustomAppBar(title: 'CLASS TEST RESULTS'),
      body: FutureBuilder(
          future: studentMarksRecords,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const CustomLoader();
              default:
                if (snapshot.hasData) {
                  return const StudentClassTestResultComponent();
                } else {
                  return ShowError(errorText: '${snapshot.error}');
                }
            }
          }),
    );
  }
}

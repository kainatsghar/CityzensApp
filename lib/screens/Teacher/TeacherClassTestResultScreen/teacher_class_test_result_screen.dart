import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/components/ClassTestResultComponents/teacher_add_class_result_component.dart';
import 'package:tcs_app/provider/ClassTestResult/class_test_result_provider.dart';

import '../../../custom_widgets/CustomAppBar/custom_app_bar.dart';
import '../../../routes/app_navigation.dart';

class TeacherClassTestResultScreen extends StatefulWidget {
  const TeacherClassTestResultScreen({super.key});

  @override
  State<TeacherClassTestResultScreen> createState() =>
      _TeacherClassTestResultScreenState();
}

class _TeacherClassTestResultScreenState
    extends State<TeacherClassTestResultScreen> {
  // late Future sections;
  var provider = Provider.of<ClassTestResultProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  @override
  void initState() {
    // sections = provider.loadSections();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'CLASS TEST RESULTS'),
      body: const TeacherAddClassResultComponent(),
      // FutureBuilder(
      //   future: sections,
      //   builder: (context, snapshot) {
      //     switch (snapshot.connectionState) {
      //       case ConnectionState.waiting:
      //         return const CustomLoader();
      //       default:
      //         if (snapshot.hasData) {
      //           return const TeacherAddClassResultComponent();
      //         } else {
      //           return ShowError(errorText: '${snapshot.error}');
      //         }
      //     }
      //   },
      // ),
    );
  }
}

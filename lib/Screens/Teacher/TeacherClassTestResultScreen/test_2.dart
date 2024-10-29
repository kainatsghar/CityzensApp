import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Components/ClassTestResultComponents/test2_component.dart';

import '../../../CustomWidgets/CustomLoader/custom_loader.dart';
import '../../../CustomWidgets/ShowError/show_error.dart';
import '../../../Provider/ClassTestResult/class_test_result_provider.dart';
import '../../../Routes/app_navigation.dart';

class Test2 extends StatefulWidget {
  const Test2({super.key});

  @override
  State<Test2> createState() => _Test2State();
}

class _Test2State extends State<Test2> {
  late Future studentRecords;
  var provider = Provider.of<ClassTestResultProvider>(
      AppNavigation.currentContext!,
      listen: false);

  @override
  void initState() {
    provider.categoryId = 2;

    studentRecords = provider.loadStudentsBySubject();
    super.initState();
  }

  // @override
  // void dispose() {
  //   provider.clearLibraryData();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        Test2Component(),
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

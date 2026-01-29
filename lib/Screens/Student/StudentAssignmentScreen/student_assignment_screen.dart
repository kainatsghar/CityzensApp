import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/components/AssignmentComponents/class_assignment_component.dart';
import 'package:tcs_app/provider/Assignment/assignment_provider.dart';

import '../../../custom_widgets/CustomAppBar/custom_app_bar.dart';
import '../../../custom_widgets/CustomLoader/custom_loader.dart';
import '../../../custom_widgets/ShowError/show_error.dart';
import '../../../routes/app_navigation.dart';

class StudentAssignmentScreen extends StatefulWidget {
  const StudentAssignmentScreen({super.key});

  @override
  State<StudentAssignmentScreen> createState() =>
      _StudentAssignmentScreenState();
}

class _StudentAssignmentScreenState extends State<StudentAssignmentScreen> {
  late Future assignmentRecords;
  var provider = Provider.of<AssignmentProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  @override
  void initState() {
    assignmentRecords = provider.loadStudentDiary();
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
      appBar: const CustomAppBar(title: 'CLASSWORK ASSIGNMENT'),
      body: FutureBuilder(
        future: assignmentRecords,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const CustomLoader();
            default:
              if (snapshot.hasData) {
                return const AssignmentRecordComponent();
              } else {
                return ShowError(errorText: '${snapshot.error}');
              }
          }
        },
      ),
    );
  }
}

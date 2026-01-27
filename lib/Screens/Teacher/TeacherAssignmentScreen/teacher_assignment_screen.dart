import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/components/AssignmentComponents/class_assignment_component.dart';
import 'package:tcs_app/Provider/Assignment/assignment_provider.dart';

import '../../../custom_widgets/CustomAppBar/custom_app_bar.dart';
import '../../../custom_widgets/CustomLoader/custom_loader.dart';
import '../../../custom_widgets/ShowError/show_error.dart';
import '../../../Routes/app_navigation.dart';
import '../../../Routes/app_navigation_routes.dart';
import '../../../Utils/app_colors.dart';

class TeacherAssignmentScreen extends StatefulWidget {
  const TeacherAssignmentScreen({super.key});

  @override
  State<TeacherAssignmentScreen> createState() =>
      _TeacherAssignmentScreenState();
}

class _TeacherAssignmentScreenState extends State<TeacherAssignmentScreen> {
  late Future assignmentRecords;
  var provider = Provider.of<AssignmentProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  @override
  void initState() {
    assignmentRecords = provider.loadTeacherAssignment();
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
      appBar: const CustomAppBar(title: 'CLASSWORK ASSIGNMENTS'),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            AppNavigation.navigateTo(AppNavRoutes.addAssignmentRoute),
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.add, color: AppColors.whiteColor),
      ),
    );
  }
}

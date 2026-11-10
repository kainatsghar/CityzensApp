import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomAppBar/cityzens_back_button.dart';
import 'package:tcs_app/CustomWidgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/CustomWidgets/ShowError/show_error.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/Utils/app_themes.dart';
import 'package:tcs_app/citizen/Components/AssignmentComponents/class_assignment_component.dart';
import 'package:tcs_app/citizen/Provider/Assignment/assignment_provider.dart';

class StudentAssignmentScreen extends StatefulWidget {
  const StudentAssignmentScreen({super.key});

  @override
  State<StudentAssignmentScreen> createState() =>
      _StudentAssignmentScreenState();
}

class _StudentAssignmentScreenState extends State<StudentAssignmentScreen> {
  late Future assignmentRecords;

  AssignmentProvider get provider => Provider.of<AssignmentProvider>(
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

  Future<void> _refreshAssignments() async {
    final Future nextFuture = provider.loadStudentDiary();
    setState(() {
      assignmentRecords = nextFuture;
    });
    await nextFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      body: Column(
        children: [
          // Blue Header matching app theme
          Container(
            width: double.infinity,
            color: AppColors.blue,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CityzensBackButton(
                      size: 40,
                      onTap: () => Navigator.of(context).maybePop(),
                    ),
                    Text(
                      'Classwork',
                      style: AppThemes.sora(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.13),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.refresh_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: _refreshAssignments,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Body
          Expanded(
            child: RefreshIndicator(
              color: AppColors.blue,
              backgroundColor: AppColors.yellow,
              onRefresh: _refreshAssignments,
              child: FutureBuilder(
                future: assignmentRecords,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Center(child: CustomLoader());
                    default:
                      if (snapshot.hasData) {
                        return const AssignmentRecordComponent();
                      } else {
                        return ShowError(errorText: '${snapshot.error}');
                      }
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

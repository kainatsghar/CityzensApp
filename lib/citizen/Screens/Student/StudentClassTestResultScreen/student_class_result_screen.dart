import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/citizen/Components/ClassTestResultComponents/student_class_test_result_component.dart';
import 'package:tcs_app/citizen/Provider/ClassTestResult/class_test_result_provider.dart';
import 'package:tcs_app/CustomWidgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/CustomWidgets/ShowError/show_error.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/Utils/app_themes.dart';
import 'package:tcs_app/CustomWidgets/CustomAppBar/cityzens_back_button.dart';

class StudentClassResultScreen extends StatefulWidget {
  const StudentClassResultScreen({super.key});

  @override
  State<StudentClassResultScreen> createState() =>
      _StudentClassResultScreenState();
}

class _StudentClassResultScreenState extends State<StudentClassResultScreen> {
  late Future studentMarksRecords;
  ClassTestResultProvider get provider =>
      Provider.of<ClassTestResultProvider>(
        AppNavigation.currentContext!,
        listen: false,
      );

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

  Widget _buildStaticHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.blue,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CityzensBackButton(
                size: 40,
                onTap: () => Navigator.of(context).pop(),
              ),
              Text(
                'Class tests',
                style: AppThemes.sora(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 40, height: 40),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      body: RefreshIndicator(
        color: AppColors.blue,
        backgroundColor: AppColors.yellow,
        onRefresh: () async {
          setState(() {
            studentMarksRecords =
                provider.loadStudentsTestResultswithMarks();
          });
        },
        child: FutureBuilder(
          future: studentMarksRecords,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Column(
                  children: [
                    _buildStaticHeader(context),
                    const Expanded(
                      child: Center(
                        child: CustomLoader(),
                      ),
                    ),
                  ],
                );
              default:
                if (snapshot.hasData) {
                  return StudentClassTestResultComponent(
                    onRefresh: () {
                      setState(() {
                        studentMarksRecords =
                            provider.loadStudentsTestResultswithMarks();
                      });
                    },
                  );
                } else {
                  return Column(
                    children: [
                      _buildStaticHeader(context),
                      Expanded(
                        child: Center(
                          child: ShowError(errorText: '${snapshot.error}'),
                        ),
                      ),
                    ],
                  );
                }
            }
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/citizen/Components/ClassTestResultComponents/student_class_test_result_component.dart';
import 'package:tcs_app/citizen/Provider/ClassTestResult/class_test_result_provider.dart';
import 'package:tcs_app/CustomWidgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/CustomWidgets/ShowError/show_error.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/Utils/app_themes.dart';

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
      decoration: const BoxDecoration(
        color: AppColors.blue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(26),
          bottomRight: Radius.circular(26),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 16, 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              Text(
                'Class tests',
                style: AppThemes.sora(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              Container(
                width: 36,
                height: 36,
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
                  onPressed: () {
                    setState(() {
                      studentMarksRecords =
                          provider.loadStudentsTestResultswithMarks();
                    });
                  },
                ),
              ),
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

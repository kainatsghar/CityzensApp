import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/CustomAppBar/custom_app_bar.dart';
import 'package:tcs_app/custom_widgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/custom_widgets/CustomStudentInfo/custom_student_info.dart';
import 'package:tcs_app/custom_widgets/ShowError/show_error.dart';
import 'package:tcs_app/custom_widgets/ShowCustomMessage/show_message_image.dart';
import 'package:tcs_app/model/ClassTestResult/student_test_result_list_response.dart';
import 'package:tcs_app/provider/ClassTestResult/class_test_result_provider.dart';
import 'package:tcs_app/provider/StudentDashboard/student_dashboard_provider.dart';
import 'package:tcs_app/provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/utils/app_colors.dart';
import 'package:tcs_app/services/FirebaseServices/app_analytics_service.dart';

class StudentClassResultScreen extends StatefulWidget {
  const StudentClassResultScreen({super.key});

  @override
  State<StudentClassResultScreen> createState() =>
      _StudentClassResultScreenState();
}

class _StudentClassResultScreenState extends State<StudentClassResultScreen> {
  late Future<StudentTestResultListResponse> _resultsFuture;

  @override
  void initState() {
    super.initState();
    AppAnalyticsService.logFeatureAccess("Class Tests");
    final provider = Provider.of<ClassTestResultProvider>(
      context,
      listen: false,
    );
    _resultsFuture = provider.loadStudentsTestResultswithMarks();
  }

  Future<void> _handleRefresh() async {
    final provider = Provider.of<ClassTestResultProvider>(
      context,
      listen: false,
    );
    final newResults = await provider.loadStudentsTestResultswithMarks(forceRefresh: true);
    setState(() {
      _resultsFuture = Future.value(newResults);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'CLASS TEST RESULTS'),
      body: FutureBuilder<StudentTestResultListResponse>(
        future: _resultsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CustomLoader();
          }

          if (snapshot.hasError) {
            return RefreshIndicator(
              color: AppColors.primaryBlue,
              onRefresh: _handleRefresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                  ShowError(errorText: snapshot.error.toString()),
                ],
              ),
            );
          }

          final response = snapshot.data;
          final hasResults = response != null &&
              response.subjectDto != null &&
              response.subjectDto!.isNotEmpty;

          return RefreshIndicator(
            color: AppColors.primaryBlue,
            onRefresh: _handleRefresh,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                SliverToBoxAdapter(
                  child: _buildReusableHeader(),
                ),
                if (!hasResults)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: ShowMessageOnImage(message: 'No results uploaded yet'),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 40),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final subject = response.subjectDto![index];
                          return FadeInUp(
                            delay: Duration(milliseconds: 50 * index),
                            child: _MultiTestSubjectCard(subject: subject),
                          );
                        },
                        childCount: response.subjectDto!.length,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Reuses [CustomStudentInfo] for consistency across student screens
  Widget _buildReusableHeader() {
    return Consumer<StudentDashboardProvider>(
      builder: (context, dashboardProvider, _) {
        final profile =
            dashboardProvider.activeChildData?.profile?.profile?.firstOrNull;

        if (profile == null) {
          final localData = Provider.of<LocalDataProvider>(
            context,
            listen: false,
          );
          return CustomStudentInfo(info: localData.userData?.info);
        }

        // Map Profile model to the structure expected by CustomStudentInfo
        final infoWrapper = {
          'rollNo': profile.studentId,
          'name': profile.name,
          'className': profile.className,
          'centerName': profile.center,
        };

        return CustomStudentInfo(info: StudentInfoWrapper(infoWrapper));
      },
    );
  }
}


class _MultiTestSubjectCard extends StatelessWidget {
  final SubjectDto subject;

  const _MultiTestSubjectCard({required this.subject});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withValues(alpha: 0.06),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: AppColors.borderGrey.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          // Subject Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withValues(alpha: 0.04),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.subject_rounded,
                    color: AppColors.primaryBlue,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  subject.subjectName?.toUpperCase() ?? 'UNKNOWN SUBJECT',
                  style: const TextStyle(
                    color: AppColors.primaryDarkBlue,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),

          // Marks Row
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTestColumn('TEST 1', 1),
                _buildVerticalDivider(),
                _buildTestColumn('TEST 2', 2),
                _buildVerticalDivider(),
                _buildTestColumn('TEST 3', 3),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 35,
      width: 1,
      color: AppColors.borderGrey.withValues(alpha: 0.4),
    );
  }

  Widget _buildTestColumn(String label, int testId) {
    final testResult = subject.categoryDto?.firstWhere(
      (c) => c.categoryId == testId,
      orElse: () => CategoryDto(obtainedMarks: null, totalMarks: null),
    );

    final bool hasMarks =
        testResult?.obtainedMarks != null && testResult?.totalMarks != null;

    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: AppColors.softGreyText.withValues(alpha: 0.8),
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 8),
          if (hasMarks)
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${testResult!.obtainedMarks}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  TextSpan(
                    text: ' / ${testResult.totalMarks}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.softGreyText.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            )
          else
            const Text(
              '--',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Colors.black12,
              ),
            ),
        ],
      ),
    );
  }
}

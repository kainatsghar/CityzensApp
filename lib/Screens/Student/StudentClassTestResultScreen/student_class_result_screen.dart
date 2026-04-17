import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/CustomAppBar/custom_app_bar.dart';
import 'package:tcs_app/custom_widgets/CustomCard/custom_card.dart';
import 'package:tcs_app/custom_widgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/custom_widgets/CustomStudentInfo/custom_student_info.dart';
import 'package:tcs_app/custom_widgets/ShowError/show_error.dart';
import 'package:tcs_app/custom_widgets/ShowCustomMessage/show_message_image.dart';
import 'package:tcs_app/custom_widgets/TabSelector/tab_selector.dart';
import 'package:tcs_app/model/ClassTestResult/student_test_result_list_response.dart';
import 'package:tcs_app/provider/ClassTestResult/class_test_result_provider.dart';
import 'package:tcs_app/provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/utils/app_colors.dart';

class StudentClassResultScreen extends StatefulWidget {
  const StudentClassResultScreen({super.key});

  @override
  State<StudentClassResultScreen> createState() =>
      _StudentClassResultScreenState();
}

class _StudentClassResultScreenState extends State<StudentClassResultScreen> {
  late Future<StudentTestResultListResponse> _resultsFuture;
  int _activeTestId = 1; // 1, 2, or 3

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ClassTestResultProvider>(
      context,
      listen: false,
    );
    _resultsFuture = provider.loadStudentsTestResultswithMarks();
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
            return ShowError(errorText: snapshot.error.toString());
          }

          final response = snapshot.data;
          if (response == null ||
              response.subjectDto == null ||
              response.subjectDto!.isEmpty) {
            return const ShowMessageOnImage(message: 'No results uploaded yet');
          }

          return Column(
            children: [
              _buildReusableHeader(),
              _buildSelectionTabs(),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: _buildTestView(response.subjectDto!, _activeTestId),
                ),
              ),
              _buildOverallSummary(response.subjectDto!),
            ],
          );
        },
      ),
    );
  }

  /// Reuses [CustomStudentInfo] for consistency across student screens
  Widget _buildReusableHeader() {
    final localData = Provider.of<LocalDataProvider>(context, listen: false);
    return CustomStudentInfo(info: localData.userData?.info);
  }

  /// Reuses [TabSelector] for symmetry with Teacher's selection pattern
  Widget _buildSelectionTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Test Category',
            style: TextStyle(
              color: AppColors.primaryDarkColor,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          TabSelector<int>(
            items: const [1, 2, 3],
            getDisplayText: (testId) => 'TEST $testId',
            onItemSelected: (testId) {
              setState(() => _activeTestId = testId);
            },
            initialItemName: 'TEST $_activeTestId',
          ),
        ],
      ),
    );
  }

  Widget _buildTestView(List<SubjectDto> subjects, int categoryId) {
    return ListView.builder(
      key: ValueKey('test_view_$categoryId'),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
      itemCount: subjects.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final subject = subjects[index];
        final testResults = subject.categoryDto?.firstWhere(
          (c) => c.categoryId == categoryId,
          orElse: () => CategoryDto(obtainedMarks: null, totalMarks: null),
        );

        return FadeInUp(
          delay: Duration(milliseconds: 50 * index),
          child: _SubjectResultCard(
            subjectName: subject.subjectName ?? 'Unknown',
            obtainedMarks: testResults?.obtainedMarks,
            totalMarks: testResults?.totalMarks,
          ),
        );
      },
    );
  }

  Widget _buildOverallSummary(List<SubjectDto> subjects) {
    int totalObtained = 0;
    int totalMax = 0;
    int subjectsWithMarks = 0;

    for (var subject in subjects) {
      final activeTest = subject.categoryDto?.firstWhere(
        (c) => c.categoryId == _activeTestId,
        orElse: () => CategoryDto(obtainedMarks: -1),
      );

      // Handle safety checks for marks calculation
      if (activeTest != null &&
          activeTest.obtainedMarks != null &&
          activeTest.obtainedMarks! >= 0 &&
          activeTest.totalMarks != null &&
          activeTest.totalMarks! > 0) {
        totalObtained += activeTest.obtainedMarks!;
        totalMax += activeTest.totalMarks!;
        subjectsWithMarks++;
      }
    }

    if (subjectsWithMarks == 0) return const SizedBox.shrink();

    final double percentage = totalMax > 0 ? (totalObtained / totalMax) : 0;

    return SlideInUp(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 35),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            CircularPercentIndicator(
              radius: 30.0,
              lineWidth: 6.0,
              percent: percentage,
              center: Text(
                "${(percentage * 100).toInt()}%",
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                ),
              ),
              progressColor: _getOverallStatusColor(percentage),
              backgroundColor: Colors.grey.shade100,
              circularStrokeCap: CircularStrokeCap.round,
              animation: true,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Overall Performance',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                  ),
                  Text(
                    '$totalObtained / $totalMax Total Marks',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: _getOverallStatusColor(percentage).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _getStatusText(percentage).toUpperCase(),
                style: TextStyle(
                  color: _getOverallStatusColor(percentage),
                  fontWeight: FontWeight.w900,
                  fontSize: 11,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getOverallStatusColor(double percentage) {
    if (percentage >= 0.8) return AppColors.successGreen;
    if (percentage >= 0.6) return AppColors.goldenYellow;
    if (percentage >= 0.4) return AppColors.warningOrange;
    return AppColors.errorRed;
  }

  String _getStatusText(double percentage) {
    if (percentage >= 0.8) return 'Excellent';
    if (percentage >= 0.6) return 'Good';
    if (percentage >= 0.4) return 'Average';
    return 'Weak';
  }
}

class _SubjectResultCard extends StatelessWidget {
  final String subjectName;
  final int? obtainedMarks;
  final int? totalMarks;
  final int index;

  const _SubjectResultCard({
    required this.subjectName,
    this.obtainedMarks,
    this.totalMarks,
    this.index = 0,
  });

  @override
  Widget build(BuildContext context) {
    final bool isGraded = totalMarks != null && totalMarks! > 0;
    final bool hasObtained = obtainedMarks != null;

    final double percentage = isGraded ? (obtainedMarks ?? 0) / totalMarks! : 0;
    final bool isDataFaulty =
        hasObtained && (obtainedMarks! > (totalMarks ?? 0)) && isGraded;

    return FadeInUp(
      delay: Duration(milliseconds: 100 * index),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primaryBlue.withOpacity(0.02),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.primaryBlue.withOpacity(0.08),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Accent Bar
                Container(
                  width: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryColor,
                  ),
                ),
                // Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          height: 44,
                          width: 44,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.assignment_outlined,
                            color: AppColors.primaryColor,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                subjectName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14,
                                  color: AppColors.primaryDarkColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              if (!isGraded)
                                Text(
                                  'Result Pending',
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11,
                                  ),
                                )
                              else if (isDataFaulty)
                                const Text(
                                  'Data Mismatch!',
                                  style: TextStyle(
                                    color: AppColors.errorRed,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 11,
                                  ),
                                )
                              else
                                Text(
                                  'Score: $obtainedMarks / $totalMarks',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (isGraded && !isDataFaulty)
                          CircularPercentIndicator(
                            radius: 22.0,
                            lineWidth: 4.0,
                            percent: percentage.clamp(0.0, 1.0),
                            center: Text(
                              "${(percentage * 100).toInt()}%",
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 9,
                              ),
                            ),
                            progressColor: _getScoreColor(percentage),
                            backgroundColor: Colors.grey.shade100,
                            circularStrokeCap: CircularStrokeCap.round,
                            animation: true,
                          )
                        else if (isDataFaulty)
                          const Icon(Icons.warning_amber_rounded,
                              color: AppColors.errorRed, size: 20)
                        else
                          const Icon(Icons.access_time_rounded,
                              color: Colors.grey, size: 18),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getScoreColor(double percentage) {
    if (percentage >= 0.8) return AppColors.successGreen;
    if (percentage >= 0.5) return AppColors.goldenYellow;
    return AppColors.errorRed;
  }
}

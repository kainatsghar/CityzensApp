import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/ShowCustomMessage/show_custom_message.dart';
import 'package:tcs_app/citizen/Model/ClassTestResult/student_test_result_list_response.dart';
import 'package:tcs_app/citizen/Provider/ClassTestResult/class_test_result_provider.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/Utils/app_themes.dart';

class StudentClassTestResultComponent extends StatelessWidget {
  final VoidCallback onRefresh;

  const StudentClassTestResultComponent({
    super.key,
    required this.onRefresh,
  });

  static const Map<String, Color> _subjectColors = {
    'English': Color(0xFF194F90),
    'Mathematics': Color(0xFFE0A21A),
    'Maths': Color(0xFFE0A21A),
    'Math': Color(0xFFE0A21A),
    'Urdu': Color(0xFF0E8A5F),
    'Science': Color(0xFFC42840),
    'Islamiyat': Color(0xFF2E7D6B),
    'Islamiat': Color(0xFF2E7D6B),
    'Computer': Color(0xFF5B4BB7),
    'Computer Science': Color(0xFF5B4BB7),
    'Social Studies': Color(0xFFB5651D),
    'History': Color(0xFF8D5B4C),
    'Geography': Color(0xFF2E86AB),
    'Art': Color(0xFFE056FD),
  };

  Color _getSubjectColor(String? name) {
    if (name == null) return AppColors.blue;
    for (final entry in _subjectColors.entries) {
      if (name.toLowerCase().contains(entry.key.toLowerCase())) {
        return entry.value;
      }
    }
    return AppColors.blue;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ClassTestResultProvider>(
      builder: (context, value, _) {
        final List<SubjectDto>? subjectList =
            value.studentTestResultListResponse?.subjectDto;

        return Column(
          children: [
            // S8 Blue Top Header
            Container(
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
                  padding: const EdgeInsets.fromLTRB(8, 4, 16, 14),
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
                          onPressed: onRefresh,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Scrollable Content
            Expanded(
              child: (subjectList == null || subjectList.isEmpty)
                  ? const Center(
                      child: ShowCustomMessage(message: 'No results uploaded'),
                    )
                  : SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // S8 Score Legend Key
                          Padding(
                            padding: const EdgeInsets.only(left: 2, bottom: 12),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              child: Row(
                                children: [
                                  _buildLegendItem(
                                    color: const Color(0xFF0E8A5F),
                                    label: '80% and above',
                                  ),
                                  const SizedBox(width: 14),
                                  _buildLegendItem(
                                    color: const Color(0xFFE0A21A),
                                    label: '50–79%',
                                  ),
                                  const SizedBox(width: 14),
                                  _buildLegendItem(
                                    color: const Color(0xFFC42840),
                                    label: 'Below 50%',
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // S8 Subject Cards List
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: subjectList.length,
                            separatorBuilder: (_, index) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final SubjectDto subject = subjectList[index];
                              return _buildSubjectCard(subject);
                            },
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLegendItem({required Color color, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 4,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: AppThemes.roboto(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.muted,
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectCard(SubjectDto subject) {
    final Color accentColor = _getSubjectColor(subject.subjectName);

    // Extract Test 1, Test 2, Test 3 categories
    CategoryDto? findTest(int categoryId) {
      if (subject.categoryDto == null) return null;
      for (final cat in subject.categoryDto!) {
        if (cat.categoryId == categoryId) {
          return cat;
        }
      }
      return null;
    }

    final CategoryDto? test1 = findTest(1);
    final CategoryDto? test2 = findTest(2);
    final CategoryDto? test3 = findTest(3);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(15, 52, 102, 0.06),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Subject Header (Accent indicator + Name)
          Row(
            children: [
              Container(
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  subject.subjectName ?? 'Subject',
                  style: AppThemes.sora(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // 3-Column Grid for Test 1, Test 2, Test 3
          Row(
            children: [
              Expanded(child: _buildTestTile(testNumber: 1, test: test1)),
              const SizedBox(width: 6),
              Expanded(child: _buildTestTile(testNumber: 2, test: test2)),
              const SizedBox(width: 6),
              Expanded(child: _buildTestTile(testNumber: 3, test: test3)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTestTile({required int testNumber, required CategoryDto? test}) {
    final bool hasTaken = (test != null &&
        test.obtainedMarks != null &&
        test.totalMarks != null &&
        test.totalMarks! > 0);

    double percentage = 0.0;
    Color bandColor = const Color(0xFFC42840);

    if (hasTaken) {
      percentage = (test.obtainedMarks! / test.totalMarks!) * 100;
      if (percentage >= 80) {
        bandColor = const Color(0xFF0E8A5F);
      } else if (percentage >= 50) {
        bandColor = const Color(0xFFE0A21A);
      } else {
        bandColor = const Color(0xFFC42840);
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.fromLTRB(8, 7, 8, 9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Test Label
          Text(
            'TEST $testNumber',
            style: AppThemes.roboto(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.4,
              color: AppColors.muted,
            ),
          ),
          const SizedBox(height: 3),

          // Score / Dash
          if (hasTaken)
            RichText(
              text: TextSpan(
                text: '${test.obtainedMarks}',
                style: AppThemes.sora(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
                children: [
                  TextSpan(
                    text: '/${test.totalMarks}',
                    style: AppThemes.roboto(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
            )
          else
            Text(
              '—',
              style: AppThemes.sora(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: const Color(0xFFA0A8B5),
              ),
            ),
          const SizedBox(height: 6),

          // Progress Bar
          Container(
            height: 4,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFE6E9EE),
              borderRadius: BorderRadius.circular(2),
            ),
            child: hasTaken
                ? FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: (percentage / 100).clamp(0.0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: bandColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

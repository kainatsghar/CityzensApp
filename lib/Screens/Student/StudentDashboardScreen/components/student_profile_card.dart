import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/CustomUserImage/custom_user_image.dart';
import 'package:tcs_app/provider/StudentDashboard/student_dashboard_provider.dart';
import 'package:tcs_app/provider/LocalData/local_data_provider.dart';
import 'package:flutter/services.dart';
import 'package:tcs_app/utils/app_colors.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:tcs_app/routes/app_navigation.dart';
import 'package:tcs_app/routes/app_navigation_routes.dart';

class StudentProfileCard extends StatelessWidget {
  final double? borderRadius;
  final EdgeInsets? padding;

  const StudentProfileCard({super.key, this.borderRadius, this.padding});

  @override
  Widget build(BuildContext context) {
    const white10 = Color(0x1AFFFFFF);
    const white15 = Color(0x26FFFFFF);
    const white40 = Color(0x66FFFFFF);
    const white80 = Color(0xCCFFFFFF);
    const whiteE6 = Color(0xE6FFFFFF);

    return Consumer2<StudentDashboardProvider, LocalDataProvider>(
      builder: (context, provider, localData, _) {
        final data = provider.activeChildData;
        final profile = data?.profile?.profile?.firstOrNull;

        final studentName = profile?.name ?? 'Student';
        final className = profile?.className ?? '';
        final branch = profile?.center ?? '';
        final studentId = localData.studentId;
        final attendanceVal =
            (data?.attendancePercentage?.data?.attendancePercentage ?? 0.0)
                .clamp(0.0, 100.0);

        final isParent = localData.userData?.userType == 'Parent';
        final children = provider.multiChildResponse?.children ?? [];
        final gradeId = localData.userData?.info?.gradeId?.toString() ?? '';
        final localGradeId = localData.gradeId?.toString() ?? '';

        return RepaintBoundary(
          child: Container(
            margin: padding ?? const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius ?? 24.0),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primaryBlue, Color(0xED002D62)],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryBlue.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius ?? 24.0),
              child: Stack(
                children: [
                  // 2. Interactive Content (Layered Above)
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isParent && children.length > 1) ...[
                          _buildChildSelector(
                            children,
                            studentId,
                            localData,
                            provider,
                          ),
                          const SizedBox(height: 16),
                          const Divider(color: white10, height: 1),
                          const SizedBox(height: 16),
                        ],
                        _buildTappableSection(
                          onTap: () => AppNavigation.navigateTo(
                            AppNavRoutes.studentProfileRoute,
                          ),
                          borderRadius: 16,
                          child: Row(
                            children: [
                              _buildProfileImage(studentId, white80),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildStudentInfo(
                                  studentName,
                                  className,
                                  branch,
                                  white15,
                                  white10,
                                  whiteE6,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),
                        _buildTappableSection(
                          onTap: () {
                            final isAdvanced =
                                ['19', '20'].contains(gradeId) ||
                                ['19', '20'].contains(localGradeId);
                            AppNavigation.navigateTo(
                              isAdvanced
                                  ? AppNavRoutes.attendanceSubjectRoute
                                  : AppNavRoutes.attendanceRoute,
                            );
                          },
                          borderRadius: 20,
                          backgroundColor: white10,
                          child: _buildAttendanceContent(
                            attendanceVal.toDouble(),
                            white10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildChildSelector(
    List<dynamic> children,
    String studentId,
    LocalDataProvider localData,
    StudentDashboardProvider provider,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'SELECT CHILD',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: AppColors.goldenYellow,
                letterSpacing: 1.5,
              ),
            ),
            Text(
              '${children.length} CHILDREN',
              style: const TextStyle(
                fontSize: 10,
                color: Color(0x99FFFFFF),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: children.map((child) {
              final isSelected = '${child.studentId}' == studentId;
              return GestureDetector(
                onTap: () {
                  if (!isSelected) {
                    HapticFeedback.lightImpact();
                    localData.setStudentId('${child.studentId}');
                    localData.setSGradeId(child.classId);
                    provider.switchActiveChild('${child.studentId}');
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.goldenYellow
                          : const Color(0x33FFFFFF),
                      width: 2,
                    ),
                  ),
                  child: CustomUserImage(
                    userId: '${child.studentId}',
                    imageSize: isSelected ? 44 : 36,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTappableSection({
    required VoidCallback onTap,
    required double borderRadius,
    required Widget child,
    Color backgroundColor = const Color(0x0DFFFFFF),
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: const Color(0x0DFFFFFF)),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildProfileImage(String studentId, Color borderColor) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: Hero(
          tag: 'student_profile_image_$studentId',
          child: CustomUserImage(userId: studentId, imageSize: 75),
        ),
      ),
    );
  }

  Widget _buildStudentInfo(
    String name,
    String className,
    String branch,
    Color detailsBg,
    Color detailsBorder,
    Color branchColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name.toUpperCase(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.goldenYellow,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  className.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primaryDarkBlue,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: detailsBg,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: detailsBorder),
              ),
              child: const Row(
                children: [
                  Text(
                    'DETAILS',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 8,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          branch.toUpperCase(),
          style: TextStyle(
            fontSize: 11,
            color: branchColor,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceContent(double value, Color progressBg) {
    return Column(
      children: [
        Row(
          children: [
            RepaintBoundary(
              child: CircularPercentIndicator(
                radius: 30.0,
                lineWidth: 7.0,
                percent: value / 100,
                center: Text(
                  '${value.toInt()}%',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                progressColor: AppColors.goldenYellow,
                backgroundColor: progressBg,
                circularStrokeCap: CircularStrokeCap.round,
                animation: false,
              ),
            ),
            const SizedBox(width: 15),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SESSION ATTENDANCE',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: AppColors.goldenYellow,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Current Session',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.calendar_month_rounded, size: 14, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'MONTHLY ATTENDANCE',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

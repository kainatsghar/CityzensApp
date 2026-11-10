import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/citizen/Components/DashboardComponents/navigational_drawer.dart';
import 'package:tcs_app/CustomWidgets/CustomUserImage/custom_user_image.dart';
import 'package:tcs_app/citizen/Provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/citizen/Provider/StudentAttendance/student_attendance_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Routes/app_navigation_routes.dart';
import 'package:tcs_app/Routes/screen_arguments.dart';
import 'package:tcs_app/citizen/Services/FCMTokenRefresh/fcm_token_refresh_service.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/Utils/app_themes.dart';
import 'package:tcs_app/Utils/helper_function.dart';
import 'package:tcs_app/CustomWidgets/CustomAppBar/cityzens_menu_button.dart';
import 'package:tcs_app/CustomWidgets/CityzensIcons/cityzens_icons.dart';

class StudentDashboardScreen extends StatefulWidget {
  final ScreenArguments? args;

  const StudentDashboardScreen({super.key, this.args});

  @override
  State<StatefulWidget> createState() => StudentDashboardScreenState();
}

class StudentDashboardScreenState extends State<StudentDashboardScreen>
    with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  LocalDataProvider get localData => Provider.of<LocalDataProvider>(
        AppNavigation.currentContext!,
        listen: false,
      );

  StudentAttendanceProvider get attendance =>
      Provider.of<StudentAttendanceProvider>(
        AppNavigation.currentContext!,
        listen: false,
      );

  Future? attendanceService;

  @override
  void initState() {
    super.initState();
    if (localData.userData?.userType != 'Parent') {
      FcmTokenRefreshService.refreshToken();
    }
    attendanceService = attendance.getAttendancePercentage();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalDataProvider>(
      builder: (context, value, _) {
        final gradeId = value.userData?.info?.gradeId?.toString() ?? '';
        final localGradeId = value.gradeId?.toString() ?? '';
        final bool isParent = value.userData?.userType == 'Parent';

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: AppColors.paper,
          drawer: isParent ? null : const NavigationalDrawer(),
          body: RefreshIndicator(
            color: AppColors.blue,
            backgroundColor: Colors.white,
            onRefresh: () async {
              setState(() {
                attendanceService = attendance.getAttendancePercentage();
              });
              await attendanceService;
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              child: Column(
                children: [
                  // S3 Top Blue Header with Profile & Attendance Summary
                  _buildHeader(context, value, isParent),

                  // S3 Body Content (Announcement card, Bento blocks, Quick buttons)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Event / Circulars Banner Card
                        _buildEventBanner(context),
                        const SizedBox(height: 10),

                        // Bento 2-Column Grid (Homework diary hero + Timetable/Classwork)
                        _buildBentoGrid(context),
                        const SizedBox(height: 14),

                        // 4-Column Quick Buttons Grid (No extra heading, matching mockup S3)
                        _buildQuickActionsGrid(
                          context,
                          value,
                          gradeId,
                          localGradeId,
                          isParent,
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

  /// Top Blue Header Section (Profile info + Term attendance summary)
  Widget _buildHeader(
    BuildContext context,
    LocalDataProvider value,
    bool isParent,
  ) {
    final String displayName = isParent
        ? (widget.args?.userName ?? value.userData?.info?.name ?? 'Student')
        : HelperFunction.noNullStringText('${value.userData?.info?.name}');

    final String className =
        value.userData?.info?.className ?? '${value.gradeId ?? '-'}';
    final String rollNo = value.studentId.isNotEmpty
        ? value.studentId
        : (value.userData?.info?.rollNo?.toString() ??
            value.userData?.userName ??
            '-');
    final String campus = value.userData?.info?.centerName ?? '';

    return Container(
      width: double.infinity,
      color: AppColors.blue,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
          child: Column(
            children: [
              // Navigation Bar Row (Menu/Back, Centered Horizontal Logo, Spacer)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  isParent
                      ? SizedBox(
                          width: 40,
                          height: 40,
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () => Navigator.of(context).maybePop(),
                            padding: EdgeInsets.zero,
                          ),
                        )
                      : CityzensMenuButton(
                          size: 40,
                          onTap: () =>
                              _scaffoldKey.currentState?.openDrawer(),
                        ),

                  // Horizontal White TCS Logo matching mockup S3
                  Expanded(
                    child: Center(
                      child: Image.asset(
                        'assets/images/logo-horizontal-white.png',
                        height: 36,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  // Balancing spacer on right so logo sits dead-center
                  const SizedBox(width: 40, height: 40),
                ],
              ),
              const SizedBox(height: 10),

              // Student Identity Row
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: CustomUserImage(
                      userId: value.userData?.userName ?? '',
                      imageSize: 52,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppThemes.sora(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _buildInfoBadge('Class', className),
                            Container(
                              height: 20,
                              width: 1,
                              color: Colors.white.withValues(alpha: 0.22),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                            ),
                            if (campus.isNotEmpty) ...[
                              Flexible(
                                child: _buildInfoBadge('Campus', campus),
                              ),
                              Container(
                                height: 20,
                                width: 1,
                                color: Colors.white.withValues(alpha: 0.22),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                              ),
                            ],
                            _buildInfoBadge('Roll no.', rollNo),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Term 1 Attendance Summary Block
              _buildAttendanceSummaryCard(),
            ],
          ),
        ),
      ),
    );
  }

  /// Small Badges for Class, Campus, Roll No
  Widget _buildInfoBadge(String label, String val) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label.toUpperCase(),
          style: AppThemes.roboto(
            fontSize: 9.5,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.6,
            color: Colors.white.withValues(alpha: 0.72),
          ),
        ),
        const SizedBox(height: 1),
        Text(
          val,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppThemes.sora(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  /// Term 1 Attendance Summary Card with Proportional Split Bar
  Widget _buildAttendanceSummaryCard() {
    return Consumer<StudentAttendanceProvider>(
      builder: (context, attendanceProvider, _) {
        final num pct =
            attendanceProvider
                .attendancePercentage
                ?.data
                ?.attendancePercentage ??
            0;
        final int cleanPct = pct.clamp(0, 100).toInt();

        final int presentFlex = cleanPct > 0 ? cleanPct : 85;
        final int absentFlex = (100 - presentFlex).clamp(0, 100);
        final int leaveFlex = (absentFlex > 2) ? 2 : 0;
        final int finalAbsent = (absentFlex - leaveFlex).clamp(0, 100);

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.13),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Term 1 attendance',
                    style: AppThemes.sora(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '$cleanPct% ',
                        style: AppThemes.sora(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.yellow,
                        ),
                      ),
                      Text(
                        'rate',
                        style: AppThemes.roboto(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.86),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 6),

              // Status Stats Row (Present, Absent, Leave)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: _buildStatDot(
                      color: const Color(0xFF4CD39B),
                      label: 'Present',
                      value: '$cleanPct%',
                    ),
                  ),
                  Flexible(
                    child: _buildStatDot(
                      color: const Color(0xFFFF7A90),
                      label: 'Absent',
                      value: '${100 - cleanPct}%',
                    ),
                  ),
                  Flexible(
                    child: _buildStatDot(
                      color: const Color(0xFFFFC94D),
                      label: 'Leave',
                      value: '$leaveFlex',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              // Proportional Split Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: Row(
                  children: [
                    Expanded(
                      flex: presentFlex,
                      child: Container(
                        height: 4,
                        color: const Color(0xFF4CD39B),
                      ),
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      flex: finalAbsent > 0 ? finalAbsent : 1,
                      child: Container(
                        height: 4,
                        color: const Color(0xFFFF7A90),
                      ),
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      flex: leaveFlex > 0 ? leaveFlex : 1,
                      child: Container(
                        height: 4,
                        color: const Color(0xFFFFC94D),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatDot({
    required Color color,
    required String label,
    required String value,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          value,
          style: AppThemes.sora(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppThemes.roboto(
            fontSize: 11.5,
            color: Colors.white.withValues(alpha: 0.86),
          ),
        ),
      ],
    );
  }

  /// Event / Circulars Banner Card matching mockup S3
  Widget _buildEventBanner(BuildContext context) {
    return GestureDetector(
      onTap: () => AppNavigation.navigateTo(AppNavRoutes.notificationsRoute),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.line),
          boxShadow: [
            BoxShadow(
              color: AppColors.blueDeep.withValues(alpha: 0.06),
              offset: const Offset(0, 1),
              blurRadius: 3,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8C4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: CityzensIcon(
                  type: CityzensIconType.event,
                  size: 28,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Circulars & Events',
                    style: AppThemes.sora(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    'Tap to view latest announcements',
                    style: AppThemes.roboto(
                      fontSize: 12,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),
            const CityzensIcon(
              type: CityzensIconType.chevronRight,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }

  /// Bento Feature Grid matching mockup S3 (Homework diary hero + 2-row mini cards)
  Widget _buildBentoGrid(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Hero Card: Homework Diary
        Expanded(
          flex: 108,
          child: GestureDetector(
            onTap: () => AppNavigation.navigateTo(
              AppNavRoutes.studentDiaryRoute,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                height: 156,
                decoration: BoxDecoration(
                  color: AppColors.blue,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.blue.withValues(alpha: 0.2),
                      offset: const Offset(0, 2),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Subtle concentric decorative arcs matching `.bx.hw::after`
                    Positioned(
                      right: -34,
                      bottom: -34,
                      child: Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.08),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withValues(alpha: 0.04),
                              spreadRadius: 18,
                            ),
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CityzensIcon(
                                type: CityzensIconType.homework,
                                size: 48,
                                primaryColor: Colors.white,
                                secondaryColor: AppColors.yellow,
                                accentColor: AppColors.blue,
                              ),
                              Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.16),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.chevron_right_rounded,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Homework\ndiary',
                            style: AppThemes.sora(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              height: 1.25,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),

        // Right Stack: Timetable + Classwork (2-row layout per mockup)
        Expanded(
          flex: 100,
          child: Column(
            children: [
              _buildBentoMiniCard(
                title: 'Timetable',
                iconType: CityzensIconType.timetable,
                iconBg: AppColors.blueTint,
                onTap: () => AppNavigation.navigateTo(
                  AppNavRoutes.teacherTimeTableRoute,
                ),
              ),
              const SizedBox(height: 8),
              _buildBentoMiniCard(
                title: 'Classwork',
                iconType: CityzensIconType.classwork,
                iconBg: const Color(0xFFFFF8C4),
                onTap: () => AppNavigation.navigateTo(
                  AppNavRoutes.studentAssignmentRoute,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 2-Row Small Bento Card for Timetable & Classwork matching `.db .bx`
  Widget _buildBentoMiniCard({
    required String title,
    required CityzensIconType iconType,
    required Color iconBg,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 74,
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 9),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.line),
          boxShadow: [
            BoxShadow(
              color: AppColors.blueDeep.withValues(alpha: 0.06),
              offset: const Offset(0, 1),
              blurRadius: 3,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: CityzensIcon(
                      type: iconType,
                      size: 24,
                    ),
                  ),
                ),
                Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    color: AppColors.blueTint,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.blue,
                    size: 15,
                  ),
                ),
              ],
            ),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppThemes.sora(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 4-Column Quick Access Action Buttons Grid matching `.db .more`
  Widget _buildQuickActionsGrid(
    BuildContext context,
    LocalDataProvider value,
    String gradeId,
    String localGradeId,
    bool isParent,
  ) {
    final List<Widget> buttons = [];

    // 1. Profile
    buttons.add(
      _buildQuickButton(
        iconType: CityzensIconType.user,
        label: 'Profile',
        onTap: () => AppNavigation.navigateTo(
          AppNavRoutes.studentProfileRoute,
        ),
      ),
    );

    // 2. Attendance
    buttons.add(
      _buildQuickButton(
        iconType: CityzensIconType.attendance,
        label: 'Attendance',
        onTap: () {
          if (gradeId == '19' ||
              gradeId == '20' ||
              localGradeId == '19' ||
              localGradeId == '20') {
            AppNavigation.navigateTo(AppNavRoutes.attendanceSubjectRoute);
          } else {
            AppNavigation.navigateTo(AppNavRoutes.attendanceRoute);
          }
        },
      ),
    );

    // 3. Term Result (conditional on grade)
    if (gradeId != '2' &&
        gradeId != '3' &&
        gradeId != '4' &&
        localGradeId != '2' &&
        localGradeId != '3' &&
        localGradeId != '4') {
      buttons.add(
        _buildQuickButton(
          iconType: CityzensIconType.results,
          label: 'Term result',
          onTap: () => AppNavigation.navigateTo(
            AppNavRoutes.academicTermRoute,
          ),
        ),
      );
    }

    // 4. Class Tests (conditional on grade)
    if (gradeId != '2' &&
        gradeId != '3' &&
        gradeId != '4' &&
        gradeId != '5' &&
        gradeId != '6' &&
        localGradeId != '2' &&
        localGradeId != '3' &&
        localGradeId != '4' &&
        localGradeId != '5' &&
        localGradeId != '6') {
      buttons.add(
        _buildQuickButton(
          iconType: CityzensIconType.tests,
          label: 'Class tests',
          onTap: () => AppNavigation.navigateTo(
            AppNavRoutes.studentClassTestResultRoute,
          ),
        ),
      );
    }

    // 5. Fees
    buttons.add(
      _buildQuickButton(
        iconType: CityzensIconType.fees,
        label: 'Fees',
        onTap: () => AppNavigation.navigateTo(AppNavRoutes.feeChallansRoute),
      ),
    );

    // 6. Circulars
    buttons.add(
      _buildQuickButton(
        iconType: CityzensIconType.circulars,
        label: 'Circulars',
        onTap: () => AppNavigation.navigateTo(AppNavRoutes.notificationsRoute),
      ),
    );

    // 7. Library
    buttons.add(
      _buildQuickButton(
        iconType: CityzensIconType.library,
        label: 'Library',
        onTap: () => AppNavigation.navigateTo(AppNavRoutes.libraryRoute),
      ),
    );

    // 8. Eye on child (for parents of early grade students)
    if ((gradeId == '2' ||
            gradeId == '3' ||
            gradeId == '4' ||
            localGradeId == '2' ||
            localGradeId == '3' ||
            localGradeId == '4') &&
        isParent) {
      buttons.add(
        _buildQuickButton(
          iconType: CityzensIconType.eyeChild,
          label: 'Eye on child',
          onTap: () => AppNavigation.navigateTo(
            AppNavRoutes.parentEyeOnYourChildRoute,
          ),
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 4,
      mainAxisSpacing: 8,
      childAspectRatio: 0.88,
      children: buttons,
    );
  }

  /// Single Quick Button with inset bottom yellow rim matching `.db .mi`
  Widget _buildQuickButton({
    required CityzensIconType iconType,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.yellow,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: AppColors.line),
              boxShadow: [
                BoxShadow(
                  color: AppColors.blueDeep.withValues(alpha: 0.06),
                  offset: const Offset(0, 1),
                  blurRadius: 3,
                ),
              ],
            ),
            child: Container(
              margin: const EdgeInsets.only(bottom: 3),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: CityzensIcon(
                  type: iconType,
                  size: 28,
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppThemes.roboto(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

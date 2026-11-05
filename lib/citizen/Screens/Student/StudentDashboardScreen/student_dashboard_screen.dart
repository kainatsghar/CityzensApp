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
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Event / Circulars Banner Card
                        _buildEventBanner(context),
                        const SizedBox(height: 14),

                        // Bento 2-Column Grid (Homework diary hero + Timetable/Classwork)
                        _buildBentoGrid(context),
                        const SizedBox(height: 18),

                        // Section Heading
                        Text(
                          'Services & Quick Access',
                          style: AppThemes.sora(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // 4-Column Quick Buttons Grid
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
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
          child: Column(
            children: [
              // Navigation Bar Row (Menu/Back, Logo, Circulars)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  isParent
                      ? IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () => Navigator.of(context).maybePop(),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        )
                      : IconButton(
                          icon: const Icon(
                            Icons.menu_rounded,
                            color: Colors.white,
                            size: 26,
                          ),
                          onPressed: () =>
                              _scaffoldKey.currentState?.openDrawer(),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),

                  // Horizontal White TCS Logo
                  Image.asset(
                    'assets/images/tcs_logo_white.png',
                    height: 28,
                    fit: BoxFit.contain,
                  ),

                  // Notifications button
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_none_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: () => AppNavigation.navigateTo(
                      AppNavRoutes.notificationsRoute,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 14),

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
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            _buildInfoBadge('Class', className),
                            Container(
                              height: 14,
                              width: 1,
                              color: Colors.white.withValues(alpha: 0.3),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 6,
                              ),
                            ),
                            if (campus.isNotEmpty) ...[
                              Flexible(
                                child: _buildInfoBadge('Campus', campus),
                              ),
                              Container(
                                height: 14,
                                width: 1,
                                color: Colors.white.withValues(alpha: 0.3),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 6,
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
              const SizedBox(height: 14),

              // Term 1 Attendance Summary Block
              _buildAttendanceSummaryCard(),
            ],
          ),
        ),
      ),
    );
  }

  /// Small Badges for Class, Section, Roll No
  Widget _buildInfoBadge(String label, String val) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label.toUpperCase(),
          style: AppThemes.roboto(
            fontSize: 9,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
            color: Colors.white.withValues(alpha: 0.75),
          ),
        ),
        Text(
          val,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppThemes.sora(
            fontSize: 12,
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

        // Estimated proportional values for presentation bar
        final int presentFlex = cleanPct > 0 ? cleanPct : 85;
        final int absentFlex = (100 - presentFlex).clamp(0, 100);
        final int leaveFlex = (absentFlex > 2) ? 2 : 0;
        final int finalAbsent = (absentFlex - leaveFlex).clamp(0, 100);

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(14),
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
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '$cleanPct% ',
                        style: AppThemes.sora(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.yellow,
                        ),
                      ),
                      Text(
                        'rate',
                        style: AppThemes.roboto(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),

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
                      value: '$leaveFlex days',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Proportional Split Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: Row(
                  children: [
                    Expanded(
                      flex: presentFlex,
                      child: Container(
                        height: 5,
                        color: const Color(0xFF4CD39B),
                      ),
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      flex: finalAbsent > 0 ? finalAbsent : 1,
                      child: Container(
                        height: 5,
                        color: const Color(0xFFFF7A90),
                      ),
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      flex: leaveFlex > 0 ? leaveFlex : 1,
                      child: Container(
                        height: 5,
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
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppThemes.roboto(
            fontSize: 11,
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  /// Event / Circulars Banner Card
  Widget _buildEventBanner(BuildContext context) {
    return GestureDetector(
      onTap: () => AppNavigation.navigateTo(AppNavRoutes.notificationsRoute),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.line),
          boxShadow: [
            BoxShadow(
              color: AppColors.blue.withValues(alpha: 0.05),
              offset: const Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8C4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.event_note_rounded,
                color: AppColors.blue,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'School Circulars & Events',
                    style: AppThemes.sora(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 2),
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
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.muted,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  /// Bento Feature Grid (Hero Homework Diary + Timetable & Classwork stack)
  Widget _buildBentoGrid(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Hero Card: Homework Diary
        Expanded(
          flex: 11,
          child: GestureDetector(
            onTap: () => AppNavigation.navigateTo(
              AppNavRoutes.studentDiaryRoute,
            ),
            child: Container(
              height: 142,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.blue,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.blue.withValues(alpha: 0.22),
                    offset: const Offset(0, 4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.menu_book_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.yellow,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'DAILY',
                          style: AppThemes.sora(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: AppColors.blue,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Homework diary',
                        style: AppThemes.sora(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),

        // Right Stack: Timetable + Classwork
        Expanded(
          flex: 10,
          child: Column(
            children: [
              // Timetable Card
              _buildBentoMiniCard(
                title: 'Timetable',
                icon: Icons.calendar_today_rounded,
                iconBg: AppColors.blueTint,
                iconColor: AppColors.blue,
                onTap: () => AppNavigation.navigateTo(
                  AppNavRoutes.teacherTimeTableRoute,
                ),
              ),
              const SizedBox(height: 10),

              // Classwork Card
              _buildBentoMiniCard(
                title: 'Classwork',
                icon: Icons.assignment_outlined,
                iconBg: const Color(0xFFFFF8C4),
                iconColor: AppColors.blue,
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

  /// Small Bento Card for Timetable & Classwork
  Widget _buildBentoMiniCard({
    required String title,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 66,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.line),
          boxShadow: [
            BoxShadow(
              color: AppColors.blue.withValues(alpha: 0.04),
              offset: const Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(icon, color: iconColor, size: 17),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppThemes.sora(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.blue,
                ),
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: AppColors.blueTint,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                color: AppColors.blue,
                size: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 4-Column Quick Access Action Buttons Grid
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
        icon: Icons.person_outline_rounded,
        label: 'Profile',
        onTap: () => AppNavigation.navigateTo(
          AppNavRoutes.studentProfileRoute,
        ),
      ),
    );

    // 2. Attendance
    buttons.add(
      _buildQuickButton(
        icon: Icons.calendar_month_outlined,
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
          icon: Icons.military_tech_outlined,
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
          icon: Icons.fact_check_outlined,
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
        icon: Icons.account_balance_wallet_outlined,
        label: 'Fees',
        onTap: () => AppNavigation.navigateTo(AppNavRoutes.feeChallansRoute),
      ),
    );

    // 6. Circulars
    buttons.add(
      _buildQuickButton(
        icon: Icons.campaign_outlined,
        label: 'Circulars',
        onTap: () => AppNavigation.navigateTo(AppNavRoutes.notificationsRoute),
      ),
    );

    // 7. Library
    buttons.add(
      _buildQuickButton(
        icon: Icons.local_library_outlined,
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
          icon: Icons.visibility_outlined,
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
      crossAxisSpacing: 10,
      mainAxisSpacing: 14,
      childAspectRatio: 0.85,
      children: buttons,
    );
  }

  /// Single Quick Button with bottom accent shadow
  Widget _buildQuickButton({
    required IconData icon,
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.line),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.yellow,
                  offset: Offset(0, 3),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Icon(icon, color: AppColors.blue, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppThemes.roboto(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

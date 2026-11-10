import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/citizen/Components/DashboardComponents/navigational_drawer.dart';
import 'package:tcs_app/citizen/Provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Routes/app_navigation_routes.dart';
import 'package:tcs_app/citizen/Services/FCMTokenRefresh/fcm_token_refresh_service.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/Utils/app_themes.dart';
import 'package:tcs_app/CustomWidgets/CustomAppBar/cityzens_menu_button.dart';

class TeacherDashboardScreen extends StatefulWidget {
  const TeacherDashboardScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return TeacherDashboardScreenState();
  }
}

class TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    FcmTokenRefreshService.refreshToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.paper,
      drawer: const NavigationalDrawer(),
      body: Consumer<LocalDataProvider>(
        builder: (context, value, _) {
          final String gradeId =
              value.userData?.info?.gradeId?.toString() ?? '';
          final String localGradeId = value.gradeId?.toString() ?? '';
          final String teacherName =
              value.userData?.info?.name?.trim() ?? 'Faculty Member';
          final String empCode =
              value.userData?.info?.rollNo?.toString() ?? value.studentId;
          final String designation =
              value.userData?.info?.className?.trim().isNotEmpty == true
                  ? value.userData!.info!.className!.trim()
                  : 'Teacher';

          final bool showEyeOnChild = (gradeId == '2' ||
              gradeId == '3' ||
              gradeId == '4' ||
              localGradeId == '2' ||
              localGradeId == '3' ||
              localGradeId == '4');

          return Column(
            children: [
              // T1 Royal Blue Header with User Info
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
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 18),
                    child: Column(
                      children: [
                        // Top Bar: Hamburger Menu, Logo, Spacer
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CityzensMenuButton(
                              onTap: () {
                                _scaffoldKey.currentState?.openDrawer();
                              },
                            ),
                            Image.asset(
                              'assets/images/logo-horizontal-white.png',
                              height: 32,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => Image.asset(
                                'assets/images/tcs_logo.png',
                                height: 32,
                              ),
                            ),
                            const SizedBox(width: 44),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Teacher Info Hero Row
                        Row(
                          children: [
                            // Circular Avatar with Yellow Ring
                            Container(
                              width: 54,
                              height: 54,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.yellow,
                                  width: 2.5,
                                ),
                              ),
                              child: ClipOval(
                                child: Consumer<LocalDataProvider>(
                                  builder: (context, localData, _) {
                                    return FutureBuilder(
                                      future: localData.loadImagePath(empCode),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData &&
                                            snapshot.data != null &&
                                            snapshot.data.toString().isNotEmpty) {
                                          return Image.file(
                                            File('${snapshot.data}'),
                                            fit: BoxFit.cover,
                                            width: 54,
                                            height: 54,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Image.asset(
                                              'assets/images/profile_avatar_yellow.png',
                                              fit: BoxFit.cover,
                                              width: 54,
                                              height: 54,
                                            ),
                                          );
                                        }
                                        return Image.asset(
                                          'assets/images/profile_avatar_yellow.png',
                                          fit: BoxFit.cover,
                                          width: 54,
                                          height: 54,
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Name & Badges
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    teacherName,
                                    style: AppThemes.sora(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Wrap(
                                    spacing: 6,
                                    runSpacing: 4,
                                    children: [
                                      _buildHeaderBadge(
                                        label: 'Designation',
                                        value: designation,
                                      ),
                                      _buildHeaderBadge(
                                        label: 'Emp. code',
                                        value: empCode,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Scrollable Dashboard Body
              Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // T1 Bento Grid (Hero: Mark Student Attendance, Stack: Timetable & Diary)
                      SizedBox(
                        height: 160,
                        child: Row(
                          children: [
                            // Left Hero Block: Mark Student Attendance
                            Expanded(
                              flex: 11,
                              child: _buildAttendanceHeroBlock(context),
                            ),
                            const SizedBox(width: 8),

                            // Right Stacked Blocks: Timetable & Homework Diary
                            Expanded(
                              flex: 10,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: _buildBentoCard(
                                      title: 'Timetable',
                                      icon: Icons.calendar_month_outlined,
                                      iconColor: AppColors.blue,
                                      iconBg: AppColors.blueTint,
                                      onTap: () => AppNavigation.navigateTo(
                                        AppNavRoutes
                                            .teacherTimeTableSectionRoute,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Expanded(
                                    child: _buildBentoCard(
                                      title: 'Homework diary',
                                      icon: Icons.menu_book_rounded,
                                      iconColor: const Color(0xFF8A5A00),
                                      iconBg: const Color(0xFFFFF8C4),
                                      onTap: () => AppNavigation.navigateTo(
                                        AppNavRoutes.teacherDiaryRoute,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Section Title: Quick Actions
                      Padding(
                        padding: const EdgeInsets.only(left: 2, bottom: 10),
                        child: Text(
                          'QUICK ACTIONS',
                          style: AppThemes.sora(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            color: AppColors.blue,
                          ),
                        ),
                      ),

                      // 4-Column Quick Actions Grid
                      GridView.count(
                        crossAxisCount: 4,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 8,
                        childAspectRatio: 0.76,
                        children: [
                          _buildQuickActionButton(
                            icon: Icons.person_outline_rounded,
                            label: 'Profile',
                            onTap: () => AppNavigation.navigateTo(
                              AppNavRoutes.teacherProfileRoute,
                            ),
                          ),
                          _buildQuickActionButton(
                            icon: Icons.person_search_outlined,
                            label: 'Mark\nunidentified',
                            onTap: () => AppNavigation.navigateTo(
                              AppNavRoutes.markUnidentifiedRoute,
                            ),
                          ),
                          _buildQuickActionButton(
                            icon: Icons.assignment_outlined,
                            label: 'Classwork',
                            onTap: () => AppNavigation.navigateTo(
                              AppNavRoutes.teacherAssignmentRoute,
                            ),
                          ),
                          _buildQuickActionButton(
                            icon: Icons.fact_check_outlined,
                            label: 'Class tests',
                            onTap: () => AppNavigation.navigateTo(
                              AppNavRoutes.teacherClassTestResultRoute,
                            ),
                          ),
                          _buildQuickActionButton(
                            icon: Icons.campaign_outlined,
                            label: 'Circular',
                            onTap: () => AppNavigation.navigateTo(
                              AppNavRoutes.addCircularRoute,
                            ),
                          ),
                          if (showEyeOnChild)
                            _buildQuickActionButton(
                              icon: Icons.visibility_outlined,
                              label: 'Eye on your\nchild',
                              isHighlighted: true,
                              onTap: () => AppNavigation.navigateTo(
                                AppNavRoutes.eyeOnYourChildRoute,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeaderBadge({
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: AppThemes.roboto(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.75),
            ),
          ),
          Text(
            value,
            style: AppThemes.sora(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceHeroBlock(BuildContext context) {
    return InkWell(
      onTap: () => AppNavigation.navigateTo(AppNavRoutes.teacherSectionRoute),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.blue,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.blue),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(15, 52, 102, 0.12),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Watermark decoration circles
            Positioned(
              right: -24,
              bottom: -24,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      Icons.how_to_reg_rounded,
                      size: 34,
                      color: Colors.white,
                    ),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.16),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Mark student\nattendance',
                  style: AppThemes.sora(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBentoCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 17,
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
                    Icons.chevron_right_rounded,
                    color: AppColors.blue,
                    size: 14,
                  ),
                ),
              ],
            ),
            Text(
              title,
              style: AppThemes.sora(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.blue,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isHighlighted = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isHighlighted ? AppColors.blueDeep : AppColors.line,
                width: isHighlighted ? 1.5 : 1,
              ),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.yellow,
                  offset: Offset(0, 3),
                  blurRadius: 0,
                ),
                BoxShadow(
                  color: Color.fromRGBO(15, 52, 102, 0.06),
                  blurRadius: 3,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: AppColors.blue,
              size: 24,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppThemes.roboto(
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
              color: AppColors.ink,
              height: 1.15,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

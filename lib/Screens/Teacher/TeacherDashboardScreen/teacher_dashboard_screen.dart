import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/components/DashboardComponents/navigational_drawer.dart';
import 'package:tcs_app/custom_widgets/CustomLogoCover/custom_logo_cover.dart';
import 'package:tcs_app/custom_widgets/CustomSnackbar/custom_snackbar.dart';
import 'package:tcs_app/custom_widgets/ShimmerEffect/dashboard_shimmer.dart';
import 'package:tcs_app/custom_widgets/TeacherProfileCard/teacher_profile_card.dart';
import 'package:tcs_app/model/TeacherSection/teacher_section_response.dart';
import 'package:tcs_app/model/SectionSubject/section_subject_response.dart';
import 'package:tcs_app/provider/Dashboard/dashboard_provider.dart';
import 'package:tcs_app/provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/provider/MarkAttendance/mark_attendance_provider.dart';
import 'package:tcs_app/provider/ClassTestResult/class_test_result_provider.dart';
import 'package:tcs_app/provider/TimeTable/timetable_provider.dart';
import 'package:tcs_app/routes/app_navigation.dart';
import 'package:tcs_app/routes/app_navigation_routes.dart';
import 'package:tcs_app/services/FCMTokenRefresh/fcm_token_refresh_service.dart';
import 'package:tcs_app/utils/app_colors.dart';
import 'package:tcs_app/utils/helper_function.dart';
import 'package:tcs_app/utils/media_query_util.dart';

import 'package:tcs_app/custom_widgets/ParticleBackground/particle_background.dart';

class TeacherDashboardScreen extends StatefulWidget {
  const TeacherDashboardScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return TeacherDashboardScreenState();
  }
}

class TeacherDashboardScreenState extends State<TeacherDashboardScreen>
    with TickerProviderStateMixin {
  DashboardProvider? dashboardProvider;
  late final AnimationController _particleController;

  @override
  void initState() {
    FcmTokenRefreshService.refreshToken();

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 35),
    )..repeat();

    // Initialize dashboard data after build phase completes
    Future.microtask(() => _initializeDashboardData());

    super.initState();
  }

  @override
  void dispose() {
    _particleController.dispose();
    super.dispose();
  }

  /// Initialize dashboard with cached sections and subjects data
  /// Only fetches data once - subsequent calls use cache
  void _initializeDashboardData() {
    if (!mounted) return;
    try {
      dashboardProvider = Provider.of<DashboardProvider>(
        context,
        listen: false,
      );
      // Only fetch if data hasn't been initialized yet
      if (!dashboardProvider!.isDashboardDataInitialized) {
        dashboardProvider!.initializeDashboardDataForTeacher();
      } else {
        debugPrint('Dashboard data already cached, skipping fetch');
      }
    } catch (ex) {
      // Error is handled in the provider, just log it here if needed
      debugPrint('Dashboard initialization error: $ex');
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'GOOD MORNING';
    } else if (hour < 17) {
      return 'GOOD AFTERNOON';
    } else {
      return 'GOOD EVENING';
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    final double itemHeight =
        ((MediaQueryUtil.isLandscape() ? size.width : size.height) -
            kToolbarHeight -
            24) /
        6;
    final double itemWidth =
        (MediaQueryUtil.isLandscape() ? size.height : size.width) / 2;

    return Consumer<LocalDataProvider>(
      builder: (context, localValue, _) {
        // final gradeId = localValue.userData?.info?.gradeId?.toString() ?? '';
        // final localGradeId = localValue.gradeId?.toString() ?? '';
        final teacherName = HelperFunction.noNullStringText(
          localValue.userData!.info!.name ?? 'CITYZENS',
        );

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.transparent,
          ),
          child: Scaffold(
            backgroundColor: AppColors.ultraLightGrey,
            drawer: const NavigationalDrawer(),
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryLightBlue.withValues(alpha: 0.8),
                    AppColors.paleYellow.withValues(alpha: 0.2),
                    AppColors.ultraLightGrey,
                  ],
                ),
              ),
              child: Stack(
                children: [
                  ParticleBackground(
                    animation: _particleController,
                    particleColor: AppColors.primaryBlue.withValues(
                      alpha: 0.12,
                    ),
                  ),
                  Consumer3<
                    DashboardProvider,
                    MarkAttendanceProvider,
                    ClassTestResultProvider
                  >(
                    builder:
                        (
                          context,
                          dashboardValue,
                          attendanceValue,
                          classTestValue,
                          _,
                        ) {
                          // Show shimmer while loading
                          if (dashboardValue.isDashboardDataLoading) {
                            return CustomScrollView(
                              slivers: [
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 16.0,
                                      right: 16.0,
                                      top: 32,
                                    ),
                                    child: const CustomLogoCover(),
                                  ),
                                ),
                                SliverPadding(
                                  padding: const EdgeInsets.fromLTRB(
                                    16.0,
                                    16.0,
                                    16.0,
                                    32,
                                  ),
                                  sliver: SliverToBoxAdapter(
                                    child: DashboardShimmer(
                                      itemWidth: itemWidth,
                                      itemHeight: itemHeight,
                                      itemCount: 6,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }

                          final hasClassSections =
                              dashboardValue.diaryFalseSectionsResponse !=
                                  null &&
                              dashboardValue
                                      .diaryFalseSectionsResponse!
                                      .section !=
                                  null &&
                              dashboardValue
                                  .diaryFalseSectionsResponse!
                                  .section!
                                  .isNotEmpty;

                          final hasSubjectSections =
                              dashboardValue
                                  .getSectionsWithDiary(true)
                                  ?.isNotEmpty ??
                              false;

                          // Show actual content when loaded
                          return RefreshIndicator(
                            onRefresh: () =>
                                dashboardValue.refreshDashboardData(),
                            color: AppColors.primaryBlue,
                            displacement: 60,
                            child: CustomScrollView(
                              physics: const AlwaysScrollableScrollPhysics(
                                parent: BouncingScrollPhysics(),
                              ),
                              slivers: [
                                // Premium Sliver App Bar
                                SliverAppBar(
                                  expandedHeight: 75,
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                  pinned: true,
                                  centerTitle: false,
                                  systemOverlayStyle: SystemUiOverlayStyle.dark
                                      .copyWith(
                                        statusBarColor: Colors.transparent,
                                      ),
                                  leading: Builder(
                                    builder: (BuildContext context) {
                                      return IconButton(
                                        icon: const Icon(
                                          Icons.menu_rounded,
                                          color: AppColors.primaryDarkBlue,
                                        ),
                                        onPressed: () =>
                                            Scaffold.of(context).openDrawer(),
                                        tooltip: MaterialLocalizations.of(
                                          context,
                                        ).openAppDrawerTooltip,
                                      );
                                    },
                                  ),
                                  title: LayoutBuilder(
                                    builder: (context, constraints) {
                                      return FadeIn(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              _getGreeting(),
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              teacherName,
                                              style: const TextStyle(
                                                color:
                                                    AppColors.primaryDarkBlue,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: -0.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),

                                // Teacher Profile Card
                                SliverToBoxAdapter(
                                  child: FadeInDown(
                                    duration: const Duration(milliseconds: 500),
                                    child: TeacherProfileCard(
                                      isMale:
                                          dashboardValue
                                                  .teacherProfileProvider
                                                  .profileResponse !=
                                              null &&
                                          dashboardValue
                                              .teacherProfileProvider
                                              .profileResponse!
                                              .isMale,
                                      onTap: () => AppNavigation.navigateTo(
                                        AppNavRoutes.teacherProfileRoute,
                                      ),
                                    ),
                                  ),
                                ),

                                // Class Teacher Hub
                                if (hasClassSections)
                                  SliverToBoxAdapter(
                                    child: FadeInUp(
                                      duration: const Duration(
                                        milliseconds: 500,
                                      ),
                                      delay: const Duration(milliseconds: 100),
                                      child: _buildClassTeacherHub(
                                        dashboardValue,
                                        attendanceValue,
                                      ),
                                    ),
                                  ),

                                // Academic Content Hub (HW/CW/Circulars)
                                if (hasSubjectSections)
                                  SliverToBoxAdapter(
                                    child: FadeInUp(
                                      duration: const Duration(
                                        milliseconds: 500,
                                      ),
                                      delay: const Duration(milliseconds: 150),
                                      child: _buildAcademicContentHub(),
                                    ),
                                  ),

                                // Subject Teacher Hub (Results)
                                if (hasSubjectSections)
                                  SliverToBoxAdapter(
                                    child: FadeInUp(
                                      duration: const Duration(
                                        milliseconds: 500,
                                      ),
                                      delay: const Duration(milliseconds: 200),
                                      child: _buildSubjectTeacherHub(
                                        dashboardValue,
                                        classTestValue,
                                      ),
                                    ),
                                  ),

                                // Quick Services Hub
                                // SliverToBoxAdapter(
                                //   child: FadeInUp(
                                //     duration: const Duration(milliseconds: 500),
                                //     delay: const Duration(milliseconds: 300),
                                //     child: _buildQuickServicesHub(),
                                //   ),
                                // ),

                                // Bottom padding
                                const SliverToBoxAdapter(
                                  child: SizedBox(height: 40),
                                ),
                              ],
                            ),
                          );
                        },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ── UI Helpers ──────────────────────────────────────────────────

  // ── Smart Hub Components ───────────────────────────────────────

  Widget _buildClassTeacherHub(
    DashboardProvider dashboard,
    MarkAttendanceProvider attendance,
  ) {
    final sections = dashboard.getSectionsWithDiary(false) ?? [];
    if (sections.isEmpty) return const SizedBox.shrink();

    // Auto-select first section if none selected
    if (attendance.sectionController.text.isEmpty && sections.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _selectClassTeacherSection(sections.first, attendance, dashboard);
      });
    }

    bool isALevel = attendance.classId == 19 || attendance.classId == 20;
    List<SectionSubject>? subjects = isALevel
        ? dashboard.getSubjectsForSection(
            classSectionId: attendance.sectionId ?? 0,
            isDiary: false,
          )
        : null;

    final localValue = Provider.of<LocalDataProvider>(context, listen: false);
    final gradeId = localValue.userData?.info?.gradeId?.toString() ?? '';
    final localGradeId = localValue.gradeId?.toString() ?? '';
    bool showEyeOnYourChild =
        gradeId == '2' ||
        gradeId == '3' ||
        gradeId == '4' ||
        localGradeId == '2' ||
        localGradeId == '3' ||
        localGradeId == '4';

    return _buildDashboardCard(
      title: 'Class Teacher',
      accentColor: AppColors.primaryBlue,
      icon: Icons.assignment_ind_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Context Selection
          _buildWrapChips<Section>(
            items: sections,
            selectedItemName: attendance.sectionController.text,
            getDisplayText: (s) => s.name ?? 'N/A',
            onSelected: (s) =>
                _selectClassTeacherSection(s, attendance, dashboard),
          ),

          if (subjects != null && subjects.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Text(
              'SUBJECTS',
              style: TextStyle(
                color: AppColors.softGreyText,
                fontWeight: FontWeight.w800,
                fontSize: 10,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 8),
            _buildWrapChips<SectionSubject>(
              items: subjects,
              selectedItemName: attendance.subjectController.text,
              getDisplayText: (s) => s.subjectName ?? 'N/A',
              onSelected: (s) =>
                  attendance.setSubjectId(s.subjectId, s.subjectName),
              isSubject: true,
            ),
          ],

          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.primaryBlue),
          const SizedBox(height: 16),

          // Actions Grid
          Row(
            children: [
              Expanded(
                child: _buildHubActionCard(
                  title: "Today's Attendance",
                  icon: Icons.check_circle_outline,
                  color: AppColors.primaryBlue,
                  isPrimary: true,
                  onTap: () {
                    attendance.setSelectedDate(DateTime.now());
                    _handleSmartNavigation(
                      attendance,
                      null,
                      AppNavRoutes.markAttendanceRoute,
                      requiresSubject: true,
                      isDiaryTrueFlow: false,
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildHubActionCard(
                  title: 'Past Attendance',
                  icon: Icons.history_rounded,
                  color: AppColors.primaryBlue,
                  isPrimary: false,
                  onTap: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now().subtract(
                        const Duration(days: 1),
                      ),
                      firstDate: DateTime(2026),
                      lastDate: DateTime.now(),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: AppColors.primaryBlue,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (selectedDate != null) {
                      attendance.setSelectedDate(selectedDate);
                      _handleSmartNavigation(
                        attendance,
                        null,
                        AppNavRoutes.markAttendanceRoute,
                        requiresSubject: true,
                        isDiaryTrueFlow: false,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildHubActionCard(
                  title: 'Timetable',
                  icon: Icons.calendar_today_outlined,
                  color: AppColors.primaryDarkColor,
                  isPrimary: false,
                  onTap: () {
                    final ttProvider = Provider.of<TimeTableProvider>(
                      context,
                      listen: false,
                    );
                    ttProvider.setSectionId(attendance.sectionId);
                    ttProvider.setClassId(attendance.classId);
                    ttProvider.sectionController.text =
                        attendance.sectionController.text;

                    _handleSmartNavigation(
                      attendance,
                      null,
                      AppNavRoutes.teacherTimeTableRoute,
                      requiresSubject: false,
                      isDiaryTrueFlow: false,
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildHubActionCard(
                  title: 'Unidentified',
                  icon: Icons.person_search_rounded,
                  color: AppColors.primaryDarkColor,
                  isPrimary: false,
                  onTap: () => AppNavigation.navigateTo(
                    AppNavRoutes.markUnidentifiedRoute,
                  ),
                ),
              ),
            ],
          ),
          if (showEyeOnYourChild) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildHubActionCard(
                    title: 'Eye On Your Child',
                    icon: Icons.visibility_outlined,
                    color: AppColors.purpleColor,
                    isPrimary: false,
                    onTap: () => AppNavigation.navigateTo(
                      AppNavRoutes.eyeOnYourChildRoute,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(child: SizedBox()), // spacer
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAcademicContentHub() {
    return _buildDashboardCard(
      title: 'Academic Content',
      accentColor: AppColors.primaryDarkBlue,
      icon: Icons.menu_book_rounded,
      child: Column(
        children: [
          _buildAcademicRow(
            title: 'Homework',
            icon: Icons.menu_book_rounded,
            accentColor: AppColors.purpleColor,
            onAdd: () => AppNavigation.navigateTo(AppNavRoutes.addDiaryRoute),
            onView: () => AppNavigation.navigateTo(
              AppNavRoutes.teacherAcademicHubRoute,
              arguments: 0,
            ),
          ),
          const Divider(height: 24, color: AppColors.primaryBlue),
          _buildAcademicRow(
            title: 'Classwork',
            icon: Icons.assignment_outlined,
            accentColor: AppColors.purpleColor,
            onAdd: () =>
                AppNavigation.navigateTo(AppNavRoutes.addAssignmentRoute),
            onView: () => AppNavigation.navigateTo(
              AppNavRoutes.teacherAcademicHubRoute,
              arguments: 1,
            ),
          ),
          const Divider(height: 24, color: AppColors.primaryBlue),
          _buildAcademicRow(
            title: 'Circulars',
            icon: Icons.campaign_outlined,
            accentColor: AppColors.purpleColor,
            onAdd: () =>
                AppNavigation.navigateTo(AppNavRoutes.addCircularRoute),
            onView: () => AppNavigation.navigateTo(
              AppNavRoutes.teacherAcademicHubRoute,
              arguments: 2,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildAcademicRow({
    required String title,
    required IconData icon,
    required Color accentColor,
    required VoidCallback onAdd,
    required VoidCallback onView,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: accentColor, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.primaryDarkBlue,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ),
        TextButton.icon(
          onPressed: () {
            HapticFeedback.lightImpact();
            onAdd();
          },
          icon: Icon(Icons.add_rounded, size: 16, color: accentColor),
          label: Text(
            'Add',
            style: TextStyle(
              color: accentColor,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
          style: TextButton.styleFrom(
            backgroundColor: accentColor.withValues(alpha: 0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        const SizedBox(width: 8),
        TextButton.icon(
          onPressed: () {
            HapticFeedback.lightImpact();
            onView();
          },
          icon: Icon(
            Icons.visibility_outlined,
            size: 16,
            color: accentColor.withValues(alpha: 0.8),
          ),
          label: Text(
            'View',
            style: TextStyle(
              color: accentColor.withValues(alpha: 0.8),
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
          style: TextButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectTeacherHub(
    DashboardProvider dashboard,
    ClassTestResultProvider classTest,
  ) {
    final sections = dashboard.getSectionsWithDiary(true) ?? [];
    if (sections.isEmpty) return const SizedBox.shrink();

    if (classTest.sectionController.text.isEmpty && sections.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _selectSubjectTeacherSection(sections.first, classTest, dashboard);
      });
    }

    final subjects = dashboard.getSubjectsForSection(
      classSectionId: classTest.sectionId ?? 0,
      isDiary: true,
    );

    return _buildDashboardCard(
      title: 'Class Test Results',
      accentColor: AppColors.purpleColor,
      icon: Icons.analytics_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeInRight(
            duration: const Duration(milliseconds: 500),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.purpleColor.withValues(alpha: 0.1),
                    AppColors.primaryBlue.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.purpleColor.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 18,
                    color: AppColors.purpleColor.withValues(alpha: 0.8),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ACTIVE SELECTION',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.0,
                            color: AppColors.softGreyText,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${classTest.sectionController.text} • ${classTest.subjectController.text.isEmpty ? "Select Subject" : classTest.subjectController.text}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryDarkBlue,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Sections Selector
          const _SelectionLabel(text: 'TARGET SECTION'),
          const SizedBox(height: 8),
          _buildWrapChips<Section>(
            items: sections,
            selectedItemName: classTest.sectionController.text,
            getDisplayText: (s) => s.name ?? 'N/A',
            onSelected: (s) =>
                _selectSubjectTeacherSection(s, classTest, dashboard),
          ),

          if (subjects != null && subjects.isNotEmpty) ...[
            const SizedBox(height: 20),
            const _SelectionLabel(text: 'SUBJECT AREA'),
            const SizedBox(height: 8),
            _buildWrapChips<SectionSubject>(
              items: subjects,
              selectedItemName: classTest.subjectController.text,
              getDisplayText: (s) => s.subjectName ?? 'N/A',
              onSelected: (s) =>
                  classTest.setSubjectId(s.subjectId, s.subjectName),
              isSubject: true,
            ),
          ],

          const SizedBox(height: 24),

          // Primary Action (High Fidelity Gradient Button)
          FadeInUp(
            duration: const Duration(milliseconds: 600),
            child: InkWell(
              onTap: () {
                _handleSmartNavigation(
                  null,
                  classTest,
                  AppNavRoutes.teacherAddClassResultRoute,
                  requiresSubject: true,
                  isDiaryTrueFlow: true,
                );
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.purpleColor,
                      AppColors.purpleColor.withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.purpleColor.withValues(alpha: 0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.add_chart_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'MARK CLASS TEST RESULTS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Helper Component for Selection Labels ───────────────────────
}

class _SelectionLabel extends StatelessWidget {
  final String text;
  const _SelectionLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.softGreyText,
        fontWeight: FontWeight.w900,
        fontSize: 10,
        letterSpacing: 1.2,
      ),
    );
  }
}

Widget _buildQuickServicesHub() {
  return _buildDashboardCard(
    title: 'Quick Services',
    accentColor: AppColors.goldenYellow,
    icon: Icons.flash_on_rounded,
    child: Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildHubActionCard(
                title: 'School Events',
                icon: Icons.event_available_rounded,
                color: AppColors.goldenYellow,
                isPrimary: false,
                onTap: () => AppNavigation.navigateTo(
                  AppNavRoutes.teacherSchoolEventsRoute,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildHubActionCard(
                title: 'Appointments',
                icon: Icons.calendar_month_rounded,
                color: AppColors.goldenYellow,
                isPrimary: false,
                onTap: () => AppNavigation.navigateTo(
                  AppNavRoutes.parentAppointmentRoute,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildHubActionCard(
                title: 'Survey',
                icon: Icons.poll_rounded,
                color: AppColors.goldenYellow,
                isPrimary: false,
                onTap: () =>
                    AppNavigation.navigateTo(AppNavRoutes.teacherSurveyRoute),
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(child: SizedBox()), // spacer
          ],
        ),
      ],
    ),
  );
}

// ── Helper Methods for Hubs ────────────────────────────────────────

void _selectClassTeacherSection(
  Section s,
  MarkAttendanceProvider attendance,
  DashboardProvider dashboard,
) {
  if (attendance.sectionId != s.classSectionId) {
    attendance.setSectionId(s.classSectionId);
    attendance.setClassId(s.classId);
    attendance.sectionController.text = s.name ?? '';
    attendance.subjectController.clear();
    attendance.setSubjectId(null, null);

    if (s.classId == 19 || s.classId == 20) {
      attendance.loadSubjects().then((_) {
        final subjects = dashboard.getSubjectsForSection(
          classSectionId: s.classSectionId ?? 0,
          isDiary: false,
        );
        if (subjects != null && subjects.isNotEmpty) {
          attendance.setSubjectId(
            subjects[0].subjectId,
            subjects[0].subjectName,
          );
        }
      });
    }
  }
}

void _selectSubjectTeacherSection(
  Section s,
  ClassTestResultProvider classTest,
  DashboardProvider dashboard,
) {
  if (classTest.sectionId != s.classSectionId) {
    classTest.setSectionId(s.classSectionId);
    classTest.sectionController.text = s.name ?? '';
    classTest.subjectController.clear();
    classTest.setSubjectId(null, null);

    classTest.loadSubjects().then((_) {
      final subjects = dashboard.getSubjectsForSection(
        classSectionId: s.classSectionId ?? 0,
        isDiary: true,
      );
      if (subjects != null && subjects.isNotEmpty) {
        classTest.setSubjectId(subjects[0].subjectId, subjects[0].subjectName);
      }
    });
  }
}

Widget _buildWrapChips<T>({
  required List<T> items,
  required String selectedItemName,
  required String Function(T) getDisplayText,
  required Function(T) onSelected,
  bool isSubject = false,
}) {
  return Wrap(
    spacing: 10.0,
    runSpacing: 10.0,
    children: items.map((item) {
      final text = getDisplayText(item);
      final isSelected = text == selectedItemName;
      return GestureDetector(
        onTap: () {
          HapticFeedback.mediumImpact();
          onSelected(item);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryBlue : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? AppColors.primaryBlue : AppColors.primaryBlue,
              width: 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primaryBlue.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isSubject && isSelected) ...[
                const Icon(Icons.book_rounded, size: 14, color: Colors.white),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  text,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : AppColors.primaryDarkBlue,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
                    fontSize: 13,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList(),
  );
}

Widget _buildHubActionCard({
  required String title,
  required IconData icon,
  required Color color,
  required bool isPrimary,
  required VoidCallback onTap,
}) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: isPrimary ? color.withValues(alpha: 0.15) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isPrimary
                ? color.withValues(alpha: 0.3)
                : AppColors.primaryBlue,
            width: 1.2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.06),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.primaryDarkBlue,
                fontWeight: isPrimary ? FontWeight.w800 : FontWeight.w700,
                fontSize: 12,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildDashboardCard({
  required String title,
  required Color accentColor,
  required Widget child,
  IconData? icon,
}) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
    decoration: BoxDecoration(
      color: AppColors.primaryLightBlue.withValues(alpha: 0.8),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: accentColor.withValues(alpha: 0.2), width: 1.5),
      boxShadow: [
        BoxShadow(
          color: accentColor.withValues(alpha: 0.08),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 18,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 12),
              if (icon != null) ...[
                Icon(icon, color: accentColor, size: 20),
                const SizedBox(width: 8),
              ],
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  color: AppColors.primaryDarkBlue.withValues(alpha: 0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    ),
  );
}

// ── Smart Navigation Guard ───────────────────────────────────────

void _handleSmartNavigation(
  MarkAttendanceProvider? attendance,
  ClassTestResultProvider? classTest,
  String route, {
  required bool requiresSubject,
  required bool isDiaryTrueFlow,
}) {
  if (isDiaryTrueFlow) {
    if (classTest?.sectionId == null) {
      showSnackBar('Please select an Active Section in Subject Teacher first.');
      return;
    }
    if (requiresSubject && classTest?.subjectId == 0) {
      showSnackBar('Please select a Subject in Subject Teacher first.');
      return;
    }
  } else {
    if (attendance?.sectionId == null) {
      showSnackBar('Please select an Active Section in Class Teacher first.');
      return;
    }
    if (requiresSubject &&
        (attendance?.classId == 19 || attendance?.classId == 20)) {
      if (attendance?.subjectId == 0) {
        showSnackBar('Please select a Subject for this A-Level class.');
        return;
      }
    }
  }

  AppNavigation.navigateTo(route);
}

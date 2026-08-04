import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/components/DashboardComponents/navigational_drawer.dart';
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
  final ValueNotifier<double> _appBarOpacityNotifier = ValueNotifier(0.0);
  late final ScrollController _scrollController;

  @override
  void initState() {
    FcmTokenRefreshService.refreshToken();

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      double offset = _scrollController.offset;
      double newOpacity = (offset / 100).clamp(0.0, 1.0);
      if (newOpacity != _appBarOpacityNotifier.value) {
        _appBarOpacityNotifier.value = newOpacity;
      }
    });

    // Initialize dashboard data after build phase completes
    Future.microtask(() => _initializeDashboardData());

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _appBarOpacityNotifier.dispose();
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

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.sizeOf(context);
    // final double itemHeight =
    //     ((MediaQueryUtil.isLandscape() ? size.width : size.height) -
    //         kToolbarHeight -
    //         24) /
    //     6;
    // final double itemWidth =
    //     (MediaQueryUtil.isLandscape() ? size.height : size.width) / 2;

    return Consumer<LocalDataProvider>(
      builder: (context, localValue, _) {
        // final gradeId = localValue.userData?.info?.gradeId?.toString() ?? '';
        // final localGradeId = localValue.gradeId?.toString() ?? '';
        final teacherName = HelperFunction.noNullStringText(
          localValue.userData?.info?.name ?? 'CITYZENS',
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
                  Consumer<DashboardProvider>(
                    builder: (context, dashboardValue, _) {
                      // Show shimmer while loading
                      if (dashboardValue.isDashboardDataLoading) {
                        return const CustomScrollView(
                          physics: NeverScrollableScrollPhysics(),
                          slivers: [
                            SliverToBoxAdapter(child: SizedBox(height: 60)),
                            SliverPadding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              sliver: SliverToBoxAdapter(
                                child: DashboardShimmer(itemCount: 6),
                              ),
                            ),
                          ],
                        );
                      }

                      final hasClassSections =
                          dashboardValue.diaryFalseSectionsResponse != null &&
                          dashboardValue.diaryFalseSectionsResponse!.section !=
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
                        onRefresh: () => dashboardValue.refreshDashboardData(),
                        color: AppColors.primaryBlue,
                        displacement: 60,
                        child: CustomScrollView(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          slivers: [
                            // Premium Sliver App Bar
                            ValueListenableBuilder<double>(
                              valueListenable: _appBarOpacityNotifier,
                              builder: (context, opacity, _) {
                                return SliverAppBar(
                                  expandedHeight: 75,
                                  backgroundColor: AppColors.white.withValues(
                                    alpha: opacity.clamp(0.0, 0.95),
                                  ),
                                  surfaceTintColor: Colors.transparent,
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
                                              HelperFunction.getGreeting(),
                                              style: const TextStyle(
                                                color: AppColors.grey500,
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
                                );
                              },
                            ),

                            // Teacher Profile Card
                            SliverToBoxAdapter(
                              child: Column(
                                children: [
                                  TeacherProfileCard(
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
                                  const SizedBox(height: 16),
                                ],
                              ),
                            ),

                            // Class Teacher Hub
                            if (hasClassSections)
                              SliverToBoxAdapter(
                                child: _buildClassTeacherHub(dashboardValue),
                              ),

                            // Academic Content Hub (HW/CW/Circulars)
                            if (hasSubjectSections)
                              SliverToBoxAdapter(
                                child: _buildAcademicContentHub(),
                              ),

                            // Subject Teacher Hub (Results)
                            if (hasSubjectSections)
                              SliverToBoxAdapter(
                                child: _buildSubjectTeacherHub(dashboardValue),
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

  Widget _buildClassTeacherHub(DashboardProvider dashboard) {
    return Consumer<MarkAttendanceProvider>(
      builder: (context, attendance, _) {
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

        // Auto-select first subject if none selected
        if (isALevel &&
            subjects != null &&
            subjects.isNotEmpty &&
            attendance.subjectController.text.isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            attendance.setSubjectId(
              subjects.first.subjectId,
              subjects.first.subjectName,
            );
          });
        }

        final localValue = Provider.of<LocalDataProvider>(
          context,
          listen: false,
        );
        final gradeId = localValue.userData?.info?.gradeId?.toString() ?? '';
        final localGradeId = localValue.gradeId?.toString() ?? '';
        bool showEyeOnYourChild =
            gradeId == '2' ||
            gradeId == '3' ||
            gradeId == '4' ||
            localGradeId == '2' ||
            localGradeId == '3' ||
            localGradeId == '4';

        final String formattedDate = DateFormat(
          'EEEE, d MMMM yyyy',
        ).format(DateTime.now());

        return _buildDashboardCard(
          title: 'Class Teacher',
          accentColor: AppColors.primaryBlue,
          icon: Icons.assignment_ind_rounded,
          backgroundColor: AppColors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Compact Context Selection
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'TARGET SECTION',
                          style: TextStyle(
                            color: AppColors.softGreyText,
                            fontWeight: FontWeight.w800,
                            fontSize: 10,
                            letterSpacing: 1.1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildWrapChips<Section>(
                          items: sections,
                          selectedItemName: attendance.sectionController.text,
                          getDisplayText: (s) => s.name ?? 'N/A',
                          onSelected: (s) => _selectClassTeacherSection(
                            s,
                            attendance,
                            dashboard,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              if (subjects != null && subjects.isNotEmpty) ...[
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'SUBJECT AREA',
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
                            onSelected: (s) => attendance.setSubjectId(
                              s.subjectId,
                              s.subjectName,
                            ),
                            isSubject: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 12),
              const Divider(height: 1, color: AppColors.black12),
              const SizedBox(height: 16),

              // Hero Action: Today's Attendance
              Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
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
                  borderRadius: BorderRadius.circular(20),
                  child: Ink(
                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.primaryColor,
                          AppColors.primaryDarkBlue,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryDarkBlue.withValues(
                            alpha: 0.3,
                          ),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.white.withValues(alpha: 0.25),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.how_to_reg_rounded,
                            color: AppColors.white,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                formattedDate.toUpperCase(),
                                style: TextStyle(
                                  color: AppColors.white.withValues(alpha: 0.8),
                                  fontWeight: FontWeight.w800,
                                  fontSize: 10,
                                  letterSpacing: 1.1,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                "MARK ATTENDANCE",
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: AppColors.white,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Secondary Actions Grid
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionTile(
                          title: 'Past Attendance',
                          icon: Icons.history_rounded,
                          color: AppColors.primaryDarkBlue,
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
                                      primary: AppColors.primaryDarkBlue,
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
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildActionTile(
                          title: 'Unidentified',
                          icon: Icons.person_search_rounded,
                          color: AppColors.errorRed,
                          onTap: () => AppNavigation.navigateTo(
                            AppNavRoutes.markUnidentifiedRoute,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionTile(
                          title: 'Timetable',
                          icon: Icons.calendar_today_outlined,
                          color: AppColors.tertiaryDark,
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
                        child: showEyeOnYourChild
                            ? _buildActionTile(
                                title: 'Eye On Child',
                                icon: Icons.visibility_outlined,
                                color: AppColors.purple,
                                onTap: () => AppNavigation.navigateTo(
                                  AppNavRoutes.eyeOnYourChildRoute,
                                ),
                              )
                            : const SizedBox(),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAcademicContentHub() {
    return _buildDashboardCard(
      title: 'Academic Content',
      accentColor: AppColors.primaryDarkBlue,
      icon: Icons.menu_book_rounded,
      backgroundColor: AppColors.white, // Clean white card background
      child: Column(
        children: [
          _buildAcademicRow(
            title: 'Homework',
            icon: Icons.menu_book_rounded,
            accentColor: AppColors.primaryBlue, // Matches Student Dashboard
            onAdd: () => AppNavigation.navigateTo(AppNavRoutes.addDiaryRoute),
            onView: () => AppNavigation.navigateTo(
              AppNavRoutes.teacherAcademicHubRoute,
              arguments: 0,
            ),
          ),
          const Divider(
            height: 24,
            color: AppColors.black12,
          ), // Neutral divider
          _buildAcademicRow(
            title: 'Classwork',
            icon: Icons.assignment_outlined,
            accentColor: AppColors.warningOrange, // Matches Student Dashboard
            onAdd: () =>
                AppNavigation.navigateTo(AppNavRoutes.addAssignmentRoute),
            onView: () => AppNavigation.navigateTo(
              AppNavRoutes.teacherAcademicHubRoute,
              arguments: 1,
            ),
          ),
          const Divider(
            height: 24,
            color: AppColors.black12,
          ), // Neutral divider
          _buildAcademicRow(
            title: 'Circulars',
            icon: Icons.campaign_outlined,
            accentColor: AppColors.successGreen, // Matches Student Dashboard
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
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onView();
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Row(
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectTeacherHub(DashboardProvider dashboard) {
    return Consumer<ClassTestResultProvider>(
      builder: (context, classTest, _) {
        final sections = dashboard.getSectionsWithDiary(true) ?? [];
        if (sections.isEmpty) return const SizedBox.shrink();

        final localValue = Provider.of<LocalDataProvider>(
          context,
          listen: false,
        );
        final gradeId = localValue.userData?.info?.gradeId?.toString() ?? '';
        final localGradeId = localValue.gradeId?.toString() ?? '';

        const hiddenResultHubGrades = {
          '2', '3', '4',
          //, '5', '6'
        };

        final bool hideResultHub =
            hiddenResultHubGrades.contains(gradeId) ||
            hiddenResultHubGrades.contains(localGradeId);

        if (hideResultHub) return const SizedBox.shrink();

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
          accentColor: AppColors.primaryBlue, // Unified to primaryBlue
          icon: Icons.analytics_rounded,
          backgroundColor: AppColors.white, // Clean white background
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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

              // Primary Action (Clean Solid Button)
              FadeInUp(
                duration: const Duration(milliseconds: 600),
                child: Material(
                  color: Colors.transparent,
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
                    borderRadius: BorderRadius.circular(16),
                    child: Ink(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryBlue.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.add_chart_rounded,
                            color: AppColors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'MARK CLASS TEST RESULTS',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
    accentColor: AppColors.secondaryColor,
    icon: Icons.flash_on_rounded,
    child: Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildActionTile(
                title: 'School Events',
                icon: Icons.event_available_rounded,
                color: AppColors.secondaryColor,
                onTap: () => AppNavigation.navigateTo(
                  AppNavRoutes.teacherSchoolEventsRoute,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionTile(
                title: 'Appointments',
                icon: Icons.calendar_month_rounded,
                color: AppColors.secondaryColor,
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
              child: _buildActionTile(
                title: 'Survey',
                icon: Icons.poll_rounded,
                color: AppColors.secondaryColor,
                onTap: () =>
                    AppNavigation.navigateTo(AppNavRoutes.teacherSurveyRoute),
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(child: SizedBox()),
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
  attendance.selectSection(s, dashboard);
}

void _selectSubjectTeacherSection(
  Section s,
  ClassTestResultProvider classTest,
  DashboardProvider dashboard,
) {
  classTest.selectSection(s, dashboard);
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
            color: isSelected ? AppColors.primaryBlue : AppColors.white,
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
                const Icon(
                  Icons.book_rounded,
                  size: 14,
                  color: AppColors.white,
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  text,
                  style: TextStyle(
                    color: isSelected
                        ? AppColors.white
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
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w800,
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

Widget _buildActionTile({
  required String title,
  required IconData icon,
  required Color color,
  required VoidCallback onTap,
}) {
  return Material(
    color: color.withValues(alpha: 0.08),
    borderRadius: BorderRadius.circular(16),
    child: InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.primaryDarkBlue,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
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
  Color? backgroundColor,
  Gradient? backgroundGradient,
}) {
  return RepaintBoundary(
    child: Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: BoxDecoration(
        color: backgroundGradient == null
            ? (backgroundColor ??
                  AppColors.primaryLightBlue.withValues(alpha: 0.8))
            : null,
        gradient: backgroundGradient,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, color: accentColor, size: 18),
                  const SizedBox(width: 10),
                ],
                Text(
                  title.toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.primaryDarkBlue,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
                const Spacer(),
                Container(
                  width: 30,
                  height: 4,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            child,
          ],
        ),
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

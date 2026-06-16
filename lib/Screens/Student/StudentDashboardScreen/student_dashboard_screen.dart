import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:tcs_app/components/DashboardComponents/navigational_drawer.dart';
import 'package:tcs_app/custom_widgets/ShimmerEffect/dashboard_shimmer.dart';
import 'package:tcs_app/screens/Student/StudentDashboardScreen/components/student_profile_card.dart';
import 'package:tcs_app/gen/assets.gen.dart';
import 'package:tcs_app/model/MultiChild/multi_child_response.dart';
import 'package:tcs_app/provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/provider/StudentDashboard/student_dashboard_provider.dart';
import 'package:tcs_app/routes/app_navigation.dart';
import 'package:tcs_app/routes/app_navigation_routes.dart';
import 'package:tcs_app/routes/screen_arguments.dart';

import 'package:tcs_app/services/FCMTokenRefresh/fcm_token_refresh_service.dart';
import 'package:tcs_app/utils/app_colors.dart';
import 'package:tcs_app/utils/helper_function.dart';

class StudentDashboardScreen extends StatefulWidget {
  final ScreenArguments? args;

  const StudentDashboardScreen({super.key, this.args});

  @override
  State<StatefulWidget> createState() {
    return StudentDashboardScreenState();
  }
}

class StudentDashboardScreenState extends State<StudentDashboardScreen>
    with WidgetsBindingObserver {
  final ValueNotifier<double> _appBarOpacityNotifier = ValueNotifier(0.0);
  late final ScrollController _scrollController;

  bool get _isParent {
    final localData = Provider.of<LocalDataProvider>(
      AppNavigation.currentContext!,
      listen: false,
    );
    return localData.userData?.userType == 'Parent';
  }

  String get _selectedChildName {
    final localData = Provider.of<LocalDataProvider>(
      AppNavigation.currentContext!,
      listen: false,
    );
    if (!_isParent) {
      return HelperFunction.noNullStringText(
        '${localData.userData?.info?.name}',
      );
    }
    final provider = Provider.of<StudentDashboardProvider>(
      AppNavigation.currentContext!,
      listen: false,
    );
    final children = provider.multiChildResponse?.children;
    if (children == null || children.isEmpty) {
      return widget.args?.userName ?? 'CITYZENS';
    }
    final currentId = localData.studentId;
    final match = children.cast<ChildInfo?>().firstWhere(
      (c) => '${c!.studentId}' == currentId,
      orElse: () => null,
    );
    return match?.studentName?.toUpperCase() ??
        children.first.studentName?.toUpperCase() ??
        'CITYZENS';
  }

  @override
  void initState() {
    super.initState();

    FcmTokenRefreshService.refreshToken();

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      double offset = _scrollController.offset;
      double newOpacity = (offset / 100).clamp(0.0, 1.0);
      if (newOpacity != _appBarOpacityNotifier.value) {
        _appBarOpacityNotifier.value = newOpacity;
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final provider = Provider.of<StudentDashboardProvider>(
        context,
        listen: false,
      );
      if (_isParent) {
        if (provider.multiChildResponse == null) {
          provider.fetchMultiChildData();
        } else {
          provider.initializeForParent(provider.multiChildResponse!.children!);
        }
      } else {
        provider.initializeForStudent();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _appBarOpacityNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String getUserName(
      LocalDataProvider localData,
      StudentDashboardProvider provider,
    ) {
      if (_isParent) {
        return _selectedChildName;
      } else {
        final profile =
            provider.activeChildData?.profile?.profile?.isNotEmpty == true
            ? provider.activeChildData!.profile!.profile!.first
            : null;
        return profile?.name ?? localData.userData?.info?.name ?? 'Student';
      }
    }

    return Consumer2<LocalDataProvider, StudentDashboardProvider>(
      builder: (context, localData, provider, _) {
        final gradeId = localData.userData?.info?.gradeId?.toString() ?? '';
        final localGradeId = localData.gradeId?.toString() ?? '';
        final userName = getUserName(localData, provider);

        return Scaffold(
          drawer: const NavigationalDrawer(),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.4, 1.0],
                colors: [
                  AppColors.whiteColor,
                  Color(0xFFF8FAFC),
                  Color(0xFFF1F5F9),
                ],
              ),
            ),
            child: Stack(
              children: [
                if (provider.isLoading && !provider.isFirstChildReady)
                  _buildLoadingState(userName)
                else if (provider.loadError != null &&
                    !provider.isFirstChildReady)
                  _buildErrorState(provider.loadError!)
                else
                  _buildDashboardContent(
                    localData,
                    provider,
                    userName,
                    gradeId,
                    localGradeId,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingState(String userName) {
    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        const SliverToBoxAdapter(child: SizedBox(height: 60)), // Top spacing
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: const DashboardShimmer(itemCount: 4),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: AppColors.lightRedColor,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            error,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              final provider = Provider.of<StudentDashboardProvider>(
                context,
                listen: false,
              );
              if (_isParent) {
                provider.fetchMultiChildData();
              } else {
                provider.initializeForStudent();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Retry Connection'),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent(
    LocalDataProvider localData,
    StudentDashboardProvider provider,
    String userName,
    String gradeId,
    String localGradeId,
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        if (_isParent) {
          await provider.refreshAllChildren();
          if (!mounted) return;
          await provider.fetchMultiChildData();
        } else {
          await provider.refreshActiveChild();
        }
      },
      child: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          ValueListenableBuilder<double>(
            valueListenable: _appBarOpacityNotifier,
            builder: (context, opacity, _) {
              return _buildAppBar(
                userName,
                isDynamic: true,
                currentOpacity: opacity,
              );
            },
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 8)),
          SliverToBoxAdapter(child: const StudentProfileCard()),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          _buildAnimatedSliver(
            _buildSubjectsCarousel(provider.activeChildData),
            delay: 50,
          ),

          // Primary Data Hubs
          _buildAnimatedSliver(
            _buildAcademicUpdatesHub(provider.activeChildData),
            delay: 100,
          ),
          _buildAnimatedSliver(
            _buildFinancialHub(provider.activeChildData),
            delay: 200,
          ),

          // Navigation Hubs
          _buildAnimatedSliver(
            _buildAcademicsNavHub(gradeId, localGradeId),
            delay: 300,
          ),
          _buildAnimatedSliver(
            _buildStudentHub(gradeId, localGradeId),
            delay: 400,
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _buildAnimatedSliver(Widget child, {required int delay}) {
    return SliverToBoxAdapter(child: child);
  }

  Widget _buildAppBar(
    String userName, {
    bool isDynamic = false,
    double currentOpacity = 1.0,
  }) {
    final double effectiveOpacity = isDynamic ? currentOpacity : 1.0;

    return SliverAppBar(
      expandedHeight: 75,
      pinned: true,
      centerTitle: false,
      elevation: 0,
      backgroundColor: AppColors.whiteColor.withValues(alpha: effectiveOpacity),
      surfaceTintColor: Colors.transparent,
      leading: Builder(
        builder: (ctx) => IconButton(
          icon: const Icon(
            Icons.menu_rounded,
            color: AppColors.primaryDarkBlue,
            size: 28,
          ),
          onPressed: () => Scaffold.of(ctx).openDrawer(),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            HelperFunction.getGreeting(),
            style: TextStyle(
              fontSize: 11,
              color: AppColors.softGreyText.withValues(
                alpha: effectiveOpacity > 0.5 ? 1.0 : 0.8,
              ),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          Text(
            userName,
            style: TextStyle(
              fontSize: 17,
              color: AppColors.primaryDarkBlue.withValues(
                alpha: effectiveOpacity > 0.5 ? 1.0 : 0.9,
              ),
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Image.asset(Assets.images.appLogo.path, height: 35, width: 35),
        ),
      ],
    );
  }

  Widget _buildAcademicUpdatesHub(ChildDashboardData? data) {
    if (data == null) return const SizedBox.shrink();

    final hw = data.latestHomework?.diaryRecords?.firstOrNull;
    final assignment = data.latestAssignments?.assignmentRecords?.firstOrNull;
    final circular = data.latestCirculars?.notifications?.firstOrNull;

    return _buildDashboardCard(
      title: 'Academic Updates',
      accentColor: AppColors.primaryBlue,
      icon: Icons.auto_stories_rounded,
      child: Column(
        children: [
          _buildUpdateItem(
            icon: Icons.menu_book_rounded,
            title: hw?.subject ?? 'Homework',
            subtitle: hw?.description ?? 'No recent homework',
            date: HelperFunction.dateFormatter(
              hw?.diaryDate ?? '',
              format: 'dd-MMM-yyyy',
            ),
            color: AppColors.primaryBlue,
            onTap: () => AppNavigation.navigateTo(
              AppNavRoutes.studentAcademicHubRoute,
              arguments: 0,
            ),
          ),
          const Divider(height: 24),
          _buildUpdateItem(
            icon: Icons.assignment_rounded,
            title: assignment?.subject ?? 'Classwork',
            subtitle: assignment?.description ?? 'No recent assignments',
            date: HelperFunction.dateFormatter(
              assignment?.classWorkDate ?? '',
              format: 'dd-MMM-yyyy',
            ),
            color: AppColors.goldenColors,
            onTap: () => AppNavigation.navigateTo(
              AppNavRoutes.studentAcademicHubRoute,
              arguments: 1,
            ),
          ),
          const Divider(height: 24),
          _buildUpdateItem(
            icon: Icons.campaign_rounded,
            title: 'Circular',
            subtitle: circular?.notifySubject ?? 'No new circulars',
            date: HelperFunction.dateFormatter(
              circular?.generatedOn ?? '',
              format: 'dd-MMM-yyyy',
            ),
            color: AppColors.successGreen,
            onTap: () => AppNavigation.navigateTo(
              AppNavRoutes.studentAcademicHubRoute,
              arguments: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String date,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: color,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 9,
                        color: AppColors.softGreyText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right_rounded, size: 18, color: color),
        ],
      ),
    );
  }

  Widget _buildFinancialHub(ChildDashboardData? data) {
    if (data == null) return const SizedBox.shrink();
    final fees = data.outstandingChallans?.outstandingList ?? [];
    double total = fees.fold(
      0.0,
      (sum, item) => sum + (item.outstandingFee ?? 0),
    );
    bool hasFees = total > 0;

    return _buildDashboardCard(
      title: 'Financial Status',
      accentColor: hasFees ? AppColors.valuesRedColors : AppColors.successGreen,
      icon: Icons.account_balance_wallet_rounded,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              HapticFeedback.selectionClick();
              AppNavigation.navigateTo(AppNavRoutes.feeChallansRoute);
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color:
                          (hasFees
                                  ? AppColors.valuesRedColors
                                  : AppColors.successGreen)
                              .withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color:
                              (hasFees
                                      ? AppColors.valuesRedColors
                                      : AppColors.successGreen)
                                  .withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      hasFees
                          ? Icons.pending_actions_rounded
                          : Icons.check_circle_rounded,
                      color: hasFees
                          ? AppColors.valuesRedColors
                          : AppColors.successGreen,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hasFees ? 'OUTSTANDING DUES' : 'FINANCIAL STATUS',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: hasFees
                                ? AppColors.valuesRedColors
                                : AppColors.successGreen,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          hasFees
                              ? NumberFormat.currency(
                                  symbol: 'Rs. ',
                                  decimalDigits: 0,
                                ).format(total)
                              : 'All Dues Cleared',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primaryDarkBlue,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.softGreyText.withValues(alpha: 0.5),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildHubActionCard(
            title: 'View Fee Bill & Payment History',
            icon: Icons.receipt_long_rounded,
            color: hasFees ? AppColors.valuesRedColors : AppColors.primaryBlue,
            onTap: () =>
                AppNavigation.navigateTo(AppNavRoutes.feeChallansRoute),
            isPrimary: true,
          ),
        ],
      ),
    );
  }

  Widget _buildAcademicsNavHub(String gradeId, String localGradeId) {
    // Check if any academic items are active
    final bool isNotGradeOne = gradeId != '1' && localGradeId != '1';
    if (!isNotGradeOne) return const SizedBox.shrink();

    return _buildDashboardCard(
      title: 'Academic Results',
      accentColor: AppColors.primaryBlue,
      icon: Icons.workspace_premium_rounded,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildHubActionCard(
                  title: 'Term Results',
                  icon: Icons.emoji_events_rounded,
                  color: AppColors.primaryBlue,
                  onTap: () =>
                      AppNavigation.navigateTo(AppNavRoutes.academicTermRoute),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildHubActionCard(
                  title: 'Class Test',
                  icon: Icons.assessment,
                  color: AppColors.primaryBlue,
                  onTap: () => AppNavigation.navigateTo(
                    AppNavRoutes.studentClassTestResultRoute,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStudentHub(String gradeId, String localGradeId) {
    bool showEYOC =
        ['2', '3', '4'].contains(gradeId) ||
        ['2', '3', '4'].contains(localGradeId);

    return _buildDashboardCard(
      title: 'Student Hub',
      accentColor: AppColors.primaryBlue,
      icon: Icons.grid_view_rounded,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [AppColors.primaryBlue, Color(0xFF003875)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryBlue.withValues(alpha: 0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  HapticFeedback.selectionClick();
                  AppNavigation.navigateTo(AppNavRoutes.teacherTimeTableRoute);
                },
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.calendar_today_rounded,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'WEEKLY SCHEDULE',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                color: AppColors.goldenYellow,
                                letterSpacing: 1.5,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'View Timetable',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildHubActionCard(
                  title: 'Library',
                  icon: Icons.local_library_rounded,
                  color: AppColors.primaryBlue,
                  onTap: () =>
                      AppNavigation.navigateTo(AppNavRoutes.libraryRoute),
                ),
              ),
              if (showEYOC) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: _buildHubActionCard(
                    title: 'Eye On Child',
                    icon: Icons.visibility_rounded,
                    color: AppColors.purpleColor,
                    onTap: () => AppNavigation.navigateTo(
                      AppNavRoutes.parentEyeOnYourChildRoute,
                    ),
                  ),
                ),
              ],
            ],
          ),
          // Hidden inactive features preserved in code
          /*
          _buildHubActionCard(title: 'Events', icon: Icons.event_note_rounded, color: AppColors.primaryBlue, onTap: null),
          _buildHubActionCard(title: 'Survey', icon: Icons.poll_rounded, color: AppColors.primaryBlue, onTap: null),
          _buildHubActionCard(title: 'Appointment', icon: Icons.edit_calendar_rounded, color: AppColors.primaryBlue, onTap: null),
          _buildHubActionCard(title: 'Withdrawal', icon: Icons.outbox_rounded, color: AppColors.primaryBlue, onTap: null),
          _buildHubActionCard(title: 'Complaints', icon: Icons.support_agent_rounded, color: AppColors.primaryBlue, onTap: null),
          */
        ],
      ),
    );
  }

  Widget _buildDashboardCard({
    required String title,
    required Color accentColor,
    required Widget child,
    IconData? icon,
  }) {
    return RepaintBoundary(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: accentColor.withValues(alpha: 0.08),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(
            color: AppColors.borderGrey.withValues(alpha: 0.5),
          ),
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
                    style: TextStyle(
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

  Widget _buildHubActionCard({
    required String title,
    required IconData icon,
    required Color color,
    required void Function()? onTap,
    bool isPrimary = false,
  }) {
    bool isDormant = onTap == null;

    return InkWell(
      onTap: () {
        if (!isDormant) {
          HapticFeedback.lightImpact();
          onTap();
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: isDormant
              ? Colors.grey.shade50
              : (isPrimary
                    ? AppColors.primaryDarkBlue
                    : color.withValues(alpha: 0.06)),
          borderRadius: BorderRadius.circular(16),
          gradient: isPrimary && !isDormant
              ? const LinearGradient(
                  colors: [AppColors.primaryBlue, AppColors.primaryDarkBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          boxShadow: isPrimary && !isDormant
              ? [
                  BoxShadow(
                    color: AppColors.primaryDarkBlue.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [
                  BoxShadow(
                    color: color.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
          border: Border.all(
            color: isDormant
                ? Colors.grey.shade200
                : (isPrimary
                      ? Colors.transparent
                      : color.withValues(alpha: 0.15)),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isDormant
                  ? Colors.grey.shade300
                  : (isPrimary ? Colors.white : color),
              size: 20,
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDormant
                      ? Colors.grey.shade400
                      : (isPrimary ? Colors.white : AppColors.primaryDarkBlue),
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  letterSpacing: 0.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorForSubject(String subjectName) {
    final hash = subjectName.hashCode;
    final hue = (hash % 360).toDouble();
    return HSLColor.fromAHSL(1.0, hue, 0.65, 0.85).toColor(); // Soft pastel
  }

  Color _getDarkColorForSubject(String subjectName) {
    final hash = subjectName.hashCode;
    final hue = (hash % 360).toDouble();
    return HSLColor.fromAHSL(
      1.0,
      hue,
      0.75,
      0.40,
    ).toColor(); // Darker text/icon
  }

  Widget _buildSubjectsCarousel(ChildDashboardData? data) {
    final subjects = data?.subjects?.studentSubjects ?? [];
    final validSubjects = subjects
        .where((s) => s.fullName != null && s.fullName!.trim().isNotEmpty)
        .toList();

    if (validSubjects.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'My Subjects & Teachers',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: AppColors.primaryDarkBlue,
              letterSpacing: 0.5,
            ),
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: validSubjects.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final subject = validSubjects[index];
              final name = subject.subjectName ?? 'Unknown';
              final teacher = subject.fullName ?? 'Unknown';
              final bgColor = _getColorForSubject(name);
              final darkColor = _getDarkColorForSubject(name);

              return Container(
                width: 220,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: darkColor.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.menu_book_rounded,
                            color: darkColor,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: darkColor,
                              height: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.person_rounded,
                            size: 12,
                            color: darkColor.withValues(alpha: 0.9),
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              teacher,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: darkColor.withValues(alpha: 0.9),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

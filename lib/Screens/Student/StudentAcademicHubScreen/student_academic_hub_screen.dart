import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/components/AssignmentComponents/class_assignment_component.dart';
import 'package:tcs_app/components/DiaryRecordComponents/diary_record_component.dart';
import 'package:tcs_app/components/NotificationComponents/notification_component.dart';
import 'package:tcs_app/custom_widgets/CustomAppBar/custom_app_bar.dart';
import 'package:tcs_app/custom_widgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/custom_widgets/ShowError/show_error.dart';
import 'package:tcs_app/provider/Assignment/assignment_provider.dart';
import 'package:tcs_app/provider/Diary/diary_provider.dart';
import 'package:tcs_app/provider/Notifications/notification_provider.dart';
import 'package:tcs_app/provider/StudentDashboard/student_dashboard_provider.dart';
import 'package:tcs_app/utils/app_colors.dart';

/// Unified Academic Hub for Students — merges Homework, Classwork, and Circulars
/// into a single premium tabbed interface matching the teacher's experience.
///
/// Accepts an optional [initialTabIndex]:
///   0 = Homework, 1 = Classwork, 2 = Circulars
class StudentAcademicHubScreen extends StatefulWidget {
  const StudentAcademicHubScreen({super.key, this.initialTabIndex = 0});

  final int initialTabIndex;

  @override
  State<StudentAcademicHubScreen> createState() =>
      _StudentAcademicHubScreenState();
}

class _StudentAcademicHubScreenState extends State<StudentAcademicHubScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  late Future _diaryFuture;
  late Future _assignmentFuture;
  late Future _circularFuture;

  late final DiaryProvider _diaryProvider;
  late final AssignmentProvider _assignmentProvider;
  late final NotificationProvider _notificationProvider;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialTabIndex.clamp(0, 2),
    );

    _diaryProvider = Provider.of<DiaryProvider>(context, listen: false);
    _assignmentProvider = Provider.of<AssignmentProvider>(
      context,
      listen: false,
    );
    _notificationProvider = Provider.of<NotificationProvider>(
      context,
      listen: false,
    );

    _initData();
  }

  void _initData() {
    final dashboardProvider = Provider.of<StudentDashboardProvider>(
      context,
      listen: false,
    );
    final activeChild = dashboardProvider.activeChildData;

    // Synchronously seed provider states to prevent any 1-frame flash of the previous child's data
    _diaryProvider.diaryResponse = activeChild?.latestHomework;
    _assignmentProvider.assignmentResponse = activeChild?.latestAssignments;
    _notificationProvider.notifications = activeChild
        ?.latestCirculars
        ?.notifications
        ?.reversed
        .toList();
    _notificationProvider.currentNotificationGroup =
        NotificationGroup.circulars;

    // 1. Homework Caching: Reuse dashboard cache, otherwise fetch from network
    if (activeChild?.latestHomework != null) {
      _diaryFuture = Future.value(activeChild!.latestHomework);
    } else {
      _diaryFuture = _diaryProvider.loadStudentDiary().then((res) {
        if (dashboardProvider.activeChildData != null) {
          dashboardProvider.activeChildData!.latestHomework = res;
        }
        return res;
      });
    }

    // 2. Classwork Caching: Reuse dashboard cache, otherwise fetch from network
    if (activeChild?.latestAssignments != null) {
      _assignmentFuture = Future.value(activeChild!.latestAssignments);
    } else {
      _assignmentFuture = _assignmentProvider.loadStudentDiary().then((res) {
        if (dashboardProvider.activeChildData != null) {
          dashboardProvider.activeChildData!.latestAssignments = res;
        }
        return res;
      });
    }

    // 3. Circulars Caching: Reuse dashboard cache, otherwise fetch from network
    if (activeChild?.latestCirculars != null) {
      _circularFuture = Future.value(activeChild!.latestCirculars);
    } else {
      _circularFuture = _notificationProvider
          .loadNotificationData(NotificationGroup.circulars)
          .then((res) {
            if (dashboardProvider.activeChildData != null) {
              dashboardProvider.activeChildData!.latestCirculars = res;
            }
            return res;
          });
    }
  }

  Future<void> _refreshData() async {
    final dashboardProvider = Provider.of<StudentDashboardProvider>(
      context,
      listen: false,
    );
    setState(() {
      _diaryFuture = _diaryProvider.loadStudentDiary().then((res) {
        if (dashboardProvider.activeChildData != null) {
          dashboardProvider.activeChildData!.latestHomework = res;
        }
        return res;
      });
      _assignmentFuture = _assignmentProvider.loadStudentDiary().then((res) {
        if (dashboardProvider.activeChildData != null) {
          dashboardProvider.activeChildData!.latestAssignments = res;
        }
        return res;
      });
      _circularFuture = _notificationProvider
          .loadNotificationData(NotificationGroup.circulars)
          .then((res) {
            if (dashboardProvider.activeChildData != null) {
              dashboardProvider.activeChildData!.latestCirculars = res;
            }
            return res;
          });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        title: 'ACADEMIC HUB',
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(
                Icons.refresh_rounded,
                color: AppColors.primaryBlue,
              ),
              tooltip: 'Refresh',
              onPressed: _refreshData,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Tab Bar ─────────────────────────────────────────────
          FadeInDown(
            duration: const Duration(milliseconds: 400),
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              decoration: BoxDecoration(
                color: AppColors.primaryLightBlue,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primaryBlue.withOpacity(0.08),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: AppColors.primaryBlue,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryBlue.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                padding: const EdgeInsets.all(4),
                labelColor: Colors.white,
                unselectedLabelColor: AppColors.primaryBlue,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                tabs: const [
                  Tab(
                    height: 38,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.menu_book_rounded, size: 16),
                        SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            'Homework',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    height: 38,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.assignment_outlined, size: 16),
                        SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            'Classwork',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    height: 38,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.campaign_outlined, size: 16),
                        SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            'Circulars',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Tab Content ─────────────────────────────────────────
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Homework Tab
                _buildFutureTab(
                  future: _diaryFuture,
                  child: const DiaryRecordComponent(),
                ),
                // Classwork Tab
                _buildFutureTab(
                  future: _assignmentFuture,
                  child: const AssignmentRecordComponent(),
                ),
                // Circulars Tab
                _buildFutureTab(
                  future: _circularFuture,
                  child: const NotificationComponent(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Wraps existing components with a FutureBuilder for loading state
  Widget _buildFutureTab({required Future future, required Widget child}) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const CustomLoader();
          default:
            if (snapshot.hasData) {
              return child;
            } else {
              return ShowError(errorText: '${snapshot.error}');
            }
        }
      },
    );
  }
}

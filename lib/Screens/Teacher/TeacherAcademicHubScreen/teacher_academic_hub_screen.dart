import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/components/AssignmentComponents/class_assignment_component.dart';
import 'package:tcs_app/components/CircularRecordComponents/circular_record_component.dart';
import 'package:tcs_app/components/DiaryRecordComponents/diary_record_component.dart';
import 'package:tcs_app/custom_widgets/CustomAppBar/custom_app_bar.dart';
import 'package:tcs_app/custom_widgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/custom_widgets/ShowError/show_error.dart';
import 'package:tcs_app/provider/Assignment/assignment_provider.dart';
import 'package:tcs_app/provider/Circular/circular_provider.dart';
import 'package:tcs_app/provider/Diary/diary_provider.dart';
import 'package:tcs_app/routes/app_navigation.dart';
import 'package:tcs_app/routes/app_navigation_routes.dart';
import 'package:tcs_app/utils/app_colors.dart';

/// Unified Academic Hub — combines Homework, Classwork, and Circulars
/// in a single tabbed screen for streamlined teacher UX.
///
/// Accepts an optional [initialTabIndex] to pre-select a tab:
///   0 = Homework, 1 = Classwork, 2 = Circulars
class TeacherAcademicHubScreen extends StatefulWidget {
  const TeacherAcademicHubScreen({super.key, this.initialTabIndex = 0});

  final int initialTabIndex;

  @override
  State<TeacherAcademicHubScreen> createState() =>
      _TeacherAcademicHubScreenState();
}

class _TeacherAcademicHubScreenState extends State<TeacherAcademicHubScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  late Future _diaryFuture;
  late Future _assignmentFuture;
  late Future _circularFuture;

  late final DiaryProvider _diaryProvider;
  late final AssignmentProvider _assignmentProvider;
  late final CircularProvider _circularProvider;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialTabIndex.clamp(0, 2),
    );

    // Load all three data sets in parallel (reusing cached values if present)
    _diaryProvider = Provider.of<DiaryProvider>(context, listen: false);
    _assignmentProvider = Provider.of<AssignmentProvider>(
      context,
      listen: false,
    );
    _circularProvider = Provider.of<CircularProvider>(context, listen: false);

    _diaryFuture = _diaryProvider.diaryResponse != null
        ? Future.value(_diaryProvider.diaryResponse)
        : _diaryProvider.loadTeacherDiary();
    _assignmentFuture = _assignmentProvider.assignmentResponse != null
        ? Future.value(_assignmentProvider.assignmentResponse)
        : _assignmentProvider.loadTeacherAssignment();
    _circularFuture = _circularProvider.circularResponse != null
        ? Future.value(_circularProvider.circularResponse)
        : _circularProvider.loadTeacherCircular();
  }

  Future<void> _refreshData() async {
    setState(() {
      _diaryFuture = _diaryProvider.loadTeacherDiary();
      _assignmentFuture = _assignmentProvider.loadTeacherAssignment();
      _circularFuture = _circularProvider.loadTeacherCircular();
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
      backgroundColor: AppColors.ultraLightGrey,
      appBar: CustomAppBar(
        title: 'ACADEMICS',
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
                  child: const CircularRecordComponent(),
                ),
              ],
            ),
          ),
        ],
      ),

      // ── Dynamic FAB ──────────────────────────────────────────────
      floatingActionButton: AnimatedBuilder(
        animation: _tabController,
        builder: (context, _) {
          return FloatingActionButton.extended(
            onPressed: _onFabPressed,
            backgroundColor: _getFabColor(),
            icon: const Icon(Icons.add, color: Colors.white),
            label: Text(
              _getFabLabel(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          );
        },
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

  void _onFabPressed() {
    switch (_tabController.index) {
      case 0:
        AppNavigation.navigateTo(AppNavRoutes.addDiaryRoute);
        break;
      case 1:
        AppNavigation.navigateTo(AppNavRoutes.addAssignmentRoute);
        break;
      case 2:
        AppNavigation.navigateTo(AppNavRoutes.addCircularRoute);
        break;
    }
  }

  Color _getFabColor() {
    switch (_tabController.index) {
      case 0:
        return AppColors.primaryBlue;
      case 1:
        return AppColors.goldenColors;
      case 2:
        return AppColors.lightRedColor;
      default:
        return AppColors.primaryBlue;
    }
  }

  String _getFabLabel() {
    switch (_tabController.index) {
      case 0:
        return 'Add Homework';
      case 1:
        return 'Add Classwork';
      case 2:
        return 'Add Circular';
      default:
        return 'Add';
    }
  }
}

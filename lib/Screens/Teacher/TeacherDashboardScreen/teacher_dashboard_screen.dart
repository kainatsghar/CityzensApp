import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/components/DashboardComponents/navigational_drawer.dart';
import 'package:tcs_app/custom_widgets/CustomAppBar/custom_app_bar.dart';
import 'package:tcs_app/custom_widgets/CustomDashboardButton/custom_dashboard_button.dart';
import 'package:tcs_app/custom_widgets/ShimmerEffect/dashboard_shimmer.dart';
import 'package:tcs_app/provider/Dashboard/dashboard_provider.dart';
import 'package:tcs_app/provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/routes/app_navigation.dart';
import 'package:tcs_app/routes/app_navigation_routes.dart';
import 'package:tcs_app/services/FCMTokenRefresh/fcm_token_refresh_service.dart';
import 'package:tcs_app/utils/helper_function.dart';
import 'package:tcs_app/utils/media_query_util.dart';

import '../../../custom_widgets/CustomLogoCover/custom_logo_cover.dart';

class TeacherDashboardScreen extends StatefulWidget {
  const TeacherDashboardScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return TeacherDashboardScreenState();
  }
}

class TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  DashboardProvider? dashboardProvider;
  @override
  void initState() {
    FcmTokenRefreshService.refreshToken();

    // Initialize dashboard data after build phase completes
    Future.microtask(() => _initializeDashboardData());

    super.initState();
  }

  /// Initialize dashboard with cached sections and subjects data
  /// Only fetches data once - subsequent calls use cache
  void _initializeDashboardData() {
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
        final gradeId = localValue.userData?.info?.gradeId?.toString() ?? '';
        final localGradeId = localValue.gradeId?.toString() ?? '';
        return SafeArea(
          child: Scaffold(
            appBar: CustomAppBar(
              title: HelperFunction.noNullStringText(
                // '${localValue.userData.info?.name ?? 'CITYZENS'}')),
                localValue.userData!.info!.name ?? 'CITYZENS',
              ),
            ),
            drawer: const NavigationalDrawer(),
            body: Consumer<DashboardProvider>(
              builder: (context, dashboardValue, _) {
                // Show shimmer while loading
                if (dashboardValue.isDashboardDataLoading) {
                  return CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 0,
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

                // Show actual content when loaded
                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 0,
                        ),
                        child: const CustomLogoCover(),
                      ),
                    ),

                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 32),
                      sliver: SliverGrid.count(
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        crossAxisCount: 2,
                        childAspectRatio: (itemWidth / itemHeight),
                        children: <Widget>[
                          CustomDashboardButton(
                            title: 'PROFILE',
                            bottomAlign: -20,
                            onTap: () => AppNavigation.navigateTo(
                              AppNavRoutes.teacherProfileRoute,
                            ),
                            imageName:
                                dashboardValue
                                            .teacherProfileProvider
                                            .profileResponse !=
                                        null &&
                                    dashboardValue
                                        .teacherProfileProvider
                                        .profileResponse!
                                        .isMale
                                ? 'profile_icon.png'
                                : 'profile_icon_female.png',
                          ),
                          if (dashboardValue.diaryFalseSectionsResponse !=
                                  null &&
                              dashboardValue
                                      .diaryFalseSectionsResponse!
                                      .section !=
                                  null &&
                              dashboardValue
                                  .diaryFalseSectionsResponse!
                                  .section!
                                  .isNotEmpty)
                            CustomDashboardButton(
                              title: 'TIMETABLE',
                              bottomAlign: -22,
                              leftAlign: -10,
                              imageHeight:
                                  MediaQueryUtil.getResponsivePercentageSize(
                                    13,
                                  ),
                              onTap: () => AppNavigation.navigateTo(
                                AppNavRoutes.teacherTimeTableSectionRoute,
                              ),
                              imageName: 'calendar.png',
                            ),
                          if (dashboardValue.diaryFalseSectionsResponse !=
                                  null &&
                              dashboardValue
                                      .diaryFalseSectionsResponse!
                                      .section !=
                                  null &&
                              dashboardValue
                                  .diaryFalseSectionsResponse!
                                  .section!
                                  .isNotEmpty)
                            CustomDashboardButton(
                              title: 'MARK STUDENT\nATTENDANCE',
                              bottomAlign: -30,
                              imageHeight:
                                  MediaQueryUtil.getResponsivePercentageSize(
                                    13,
                                  ),
                              onTap: () => AppNavigation.navigateTo(
                                AppNavRoutes.teacherSectionRoute,
                              ),
                              imageName: 'attendance_icon.png',
                            ),
                          if (dashboardValue.diaryFalseSectionsResponse !=
                                  null &&
                              dashboardValue
                                      .diaryFalseSectionsResponse!
                                      .section !=
                                  null &&
                              dashboardValue
                                  .diaryFalseSectionsResponse!
                                  .section!
                                  .isNotEmpty)
                            CustomDashboardButton(
                              title: 'MARK\nUNIDENTIFIED',
                              bottomAlign: -38,
                              leftAlign: -15,
                              onTap: () => AppNavigation.navigateTo(
                                AppNavRoutes.markUnidentifiedRoute,
                              ),
                              imageName: 'unidentified_icon.png',
                            ),
                          CustomDashboardButton(
                            title: 'HOMEWORK\nDIARY',
                            bottomAlign: -20,
                            leftAlign: -10,
                            onTap: () => AppNavigation.navigateTo(
                              AppNavRoutes.teacherDiaryRoute,
                            ),
                            imageName: 'diary_icon.png',
                          ),

                          CustomDashboardButton(
                            title: 'CLASSWORK\nASSIGNMENTS',
                            bottomAlign: -65,
                            leftAlign: -50,
                            imageHeight:
                                MediaQueryUtil.getResponsivePercentageSize(20),
                            onTap: () => AppNavigation.navigateTo(
                              AppNavRoutes.teacherAssignmentRoute,
                            ),
                            imageName: 'assignment_icon_h.png',
                          ),
                          // CustomDashboardButton(
                          //     title: 'SCHOOL\nEVENTS',
                          //     bottomAlign: -22,
                          //     leftAlign: -10,
                          //     imageHeight: MediaQueryUtil.getResponsivePercentageSize(13),
                          //     onTap: () => AppNavigation.navigateTo(
                          //         AppNavRoutes.teacherSchoolEventsRoute),
                          //     imageName: 'calendar.png'),
                          CustomDashboardButton(
                            title: 'CLASS TEST\nRESULTS',
                            bottomAlign: -65,
                            leftAlign: -65,
                            imageHeight:
                                MediaQueryUtil.getResponsivePercentageSize(24),
                            onTap: () => AppNavigation.navigateTo(
                              AppNavRoutes.teacherClassTestResultRoute,
                            ),
                            imageName: 'class_result.png',
                          ),
                          CustomDashboardButton(
                            title: 'CIRCULAR',
                            bottomAlign: -14,
                            leftAlign: -10,
                            imageHeight:
                                MediaQueryUtil.getResponsivePercentageSize(11),
                            onTap: () => AppNavigation.navigateTo(
                              AppNavRoutes.addCircularRoute,
                            ),
                            imageName: 'notification_icon.png',
                          ),
                          // CustomDashboardButton(
                          //     title: 'APPOINTMENTS',
                          //     bottomAlign: -12,
                          //     leftAlign: 0,
                          //     imageHeight: MediaQueryUtil.getResponsivePercentageSize(10),
                          //     onTap: () => AppNavigation.navigateTo(
                          //         AppNavRoutes.parentAppointmentRoute),
                          //     imageName: 'calendar_appoointment.png'),
                          if (gradeId == '2' ||
                              gradeId == '3' ||
                              gradeId == '4' ||
                              localGradeId == '2' ||
                              localGradeId == '3' ||
                              localGradeId == '4')
                            CustomDashboardButton(
                              title: 'EYE ON\nYOUR CHILD',
                              bottomAlign: -22,
                              leftAlign: 0,
                              imageHeight:
                                  MediaQueryUtil.getResponsivePercentageSize(
                                    10,
                                  ),
                              onTap: () => AppNavigation.navigateTo(
                                AppNavRoutes.eyeOnYourChildRoute,
                              ),
                              imageName: 'shield.png',
                            ),

                          // CustomDashboardButton(
                          //     title: 'SURVEY',
                          //     bottomAlign: -14,
                          //     leftAlign: -10,
                          //     imageHeight: MediaQueryUtil.getResponsivePercentageSize(11),
                          //     onTap: () => AppNavigation.navigateTo(
                          //         AppNavRoutes.teacherSurveyRoute),
                          //     imageName: 'survey.png'),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

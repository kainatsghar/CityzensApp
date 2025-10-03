import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Components/DashboardComponents/navigational_drawer.dart';
import 'package:tcs_app/CustomWidgets/CustomAppBar/custom_app_bar.dart';
import 'package:tcs_app/CustomWidgets/CustomDashboardButton/custom_dashboard_button.dart';
import 'package:tcs_app/Provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Routes/app_navigation_routes.dart';
import 'package:tcs_app/Services/FCMTokenRefresh/fcm_token_refresh_service.dart';
import 'package:tcs_app/Utils/helper_function.dart';
import 'package:tcs_app/Utils/media_query_util.dart';

import '../../../CustomWidgets/CustomLogoCover/custom_logo_cover.dart';

class TeacherDashboardScreen extends StatefulWidget {
  const TeacherDashboardScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return TeacherDashboardScreenState();
  }
}

class TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  @override
  void initState() {
    FcmTokenRefreshService.refreshToken();
    super.initState();
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
      builder: (context, value, _) {
        // final gradeId = value.userData?.info?.gradeId?.toString() ?? '';
        // final localGradeId = value.gradeId?.toString() ?? '';
        return SafeArea(
          child: Scaffold(
            appBar: CustomAppBar(
              title: HelperFunction.noNullStringText(
                // '${value.userData.info?.name ?? 'CITYZENS'}')),
                value.userData!.info!.name ?? 'CITYZENS',
              ),
            ),
            drawer: const NavigationalDrawer(),
            body: CustomScrollView(
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
                        imageName: 'profile_icon.png',
                      ),
                      CustomDashboardButton(
                        title: 'TIMETABLE',
                        bottomAlign: -22,
                        leftAlign: -10,
                        imageHeight: MediaQueryUtil.getResponsivePercentageSize(
                          13,
                        ),
                        onTap: () => AppNavigation.navigateTo(
                          AppNavRoutes.teacherTimeTableSectionRoute,
                        ),
                        imageName: 'calendar.png',
                      ),
                      CustomDashboardButton(
                        title: 'MARK STUDENT\nATTENDANCE',
                        bottomAlign: -30,
                        imageHeight: MediaQueryUtil.getResponsivePercentageSize(
                          13,
                        ),
                        onTap: () => AppNavigation.navigateTo(
                          AppNavRoutes.teacherSectionRoute,
                        ),
                        imageName: 'attendance_icon.png',
                      ),
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
                        imageHeight: MediaQueryUtil.getResponsivePercentageSize(
                          20,
                        ),
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
                        imageHeight: MediaQueryUtil.getResponsivePercentageSize(
                          24,
                        ),
                        onTap: () => AppNavigation.navigateTo(
                          AppNavRoutes.teacherClassTestResultRoute,
                        ),
                        imageName: 'class_result.png',
                      ),
                      CustomDashboardButton(
                        title: 'CIRCULAR',
                        bottomAlign: -14,
                        leftAlign: -10,
                        imageHeight: MediaQueryUtil.getResponsivePercentageSize(
                          11,
                        ),
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
                      // if (gradeId == '2' ||
                      //     gradeId == '3' ||
                      //     gradeId == '4' ||
                      //     localGradeId == '2' ||
                      //     localGradeId == '3' ||
                      //     localGradeId == '4')
                      CustomDashboardButton(
                        title: 'EYE ON\nYOUR CHILD',
                        bottomAlign: -22,
                        leftAlign: 0,
                        imageHeight: MediaQueryUtil.getResponsivePercentageSize(
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
            ),
          ),
        );
      },
    );
  }
}

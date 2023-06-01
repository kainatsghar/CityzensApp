import 'package:flutter/material.dart';
import 'package:tcs_app/Components/DashboardComponents/navigational_drawer.dart';
import 'package:tcs_app/CustomWidgets/CustomAppbar/custom_appbar.dart';
import 'package:tcs_app/CustomWidgets/CustomDashboardButton/custom_dashboard_button.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Routes/app_navigation_routes.dart';
import 'package:tcs_app/Services/FCMTokenRefresh/fcm_token_refresh_service.dart';

import '../../../CustomWidgets/CustomLogoCover/custom_logo_cover.dart';

class TeacherDashboardScreen extends StatefulWidget {
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: CustomAppBar(title: 'CITYZENS'),
        drawer: NavigationalDrawer(),
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
            child: Column(
              children: [
                CustomLogoCover(),
                SizedBox(height: size.height * 0.02),
                Flexible(
                  child: GridView.count(
                    shrinkWrap: true,
                    primary: false,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    crossAxisCount: 2,
                    childAspectRatio: 1.65,
                    children: <Widget>[
                      CustomDashboardButton(
                          title: 'PROFILE',
                          bottomAlign: -20,
                          onTap: () => AppNavigation.navigateTo(
                              AppNavRoutes.teacherProfileRoute),
                          imageName: 'profile_icon.png'),
                      CustomDashboardButton(
                        title: 'ATTENDANCE',
                          bottomAlign: -22,
                          imageHeight: size.height * 0.13,
                          onTap: () => AppNavigation.navigateTo(
                              AppNavRoutes.teacherSectionRoute),
                          imageName: 'attendance_icon.png'),
                      CustomDashboardButton(
                          title: 'HOMEWORK\nDIARY',
                          bottomAlign: -20,
                          leftAlign: -10,
                          onTap: () => AppNavigation.navigateTo(
                              AppNavRoutes.teacherDiaryRoute),
                          imageName: 'diary_icon.png'),
                      CustomDashboardButton(
                          title: 'MARK\nUNIDENTIFIED',
                          bottomAlign: -30,
                          leftAlign: -15,
                          onTap: () => AppNavigation.navigateTo(
                              AppNavRoutes.markUnidentifiedRoute),
                          imageName: 'unidentified_icon.png')
                    ],
                  ),
                ),
              ],
            )));
  }
}

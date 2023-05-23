import 'package:flutter/material.dart';
import 'package:tcs_app/Components/DashboardComponents/navigational_drawer.dart';
import 'package:tcs_app/CustomWidgets/CustomAppbar/custom_appbar.dart';
import 'package:tcs_app/CustomWidgets/CustomDashboardButton/custom_dashboard_button.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Routes/app_navigation_routes.dart';
import 'package:tcs_app/Services/FCMTokenRefresh/fcm_token_refresh_service.dart';

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
    return Scaffold(
        appBar: CustomAppBar(title: 'Cityzens'),
        drawer: NavigationalDrawer(),
        body: Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(30.0),
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 15.0,
              crossAxisCount: 2,
              children: <Widget>[
                CustomDashboardButton(
                    buttonTitle: 'Profile',
                    onTap: () => AppNavigation.navigateTo(
                        AppNavRoutes.teacherProfileRoute),
                    imageName: 'profile.png'),
                CustomDashboardButton(
                    buttonTitle: 'Attendance',
                    onTap: () => AppNavigation.navigateTo(
                        AppNavRoutes.teacherSectionRoute),
                    imageName: 'result.png'),
                CustomDashboardButton(
                    buttonTitle: 'Diary',
                    onTap: () => AppNavigation.navigateTo(
                        AppNavRoutes.teacherDiaryRoute),
                    imageName: 'diary.png'),
                CustomDashboardButton(
                    buttonTitle: 'Mark\nUnidentified',
                    onTap: () => AppNavigation.navigateTo(
                        AppNavRoutes.markUnidentifiedRoute),
                    imageName: 'unverified.png')
              ],
            )));
  }
}

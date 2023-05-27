import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Components/DashboardComponents/navigational_drawer.dart';
import 'package:tcs_app/CustomWidgets/CustomAppbar/custom_appbar.dart';
import 'package:tcs_app/CustomWidgets/CustomDashboardButton/custom_dashboard_button.dart';
import 'package:tcs_app/Provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Routes/app_navigation_routes.dart';
import 'package:tcs_app/Services/FCMTokenRefresh/fcm_token_refresh_service.dart';

class StudentDashboardScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StudentDashboardScreenState();
  }
}

class StudentDashboardScreenState extends State<StudentDashboardScreen>
    with WidgetsBindingObserver {
  var localData = Provider.of<LocalDataProvider>(AppNavigation.currentContext,
      listen: false);

  @override
  void initState() {
    if (localData.userData.userType != 'Parent')
      FcmTokenRefreshService.refreshToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalDataProvider>(builder: (context, value, _) {
      return Scaffold(
          appBar: CustomAppBar(title: 'CITYZENS', isDrawer: true),
          drawer:
              value.userData.userType == 'Parent' ? null : NavigationalDrawer(),
          body: GridView.count(
              shrinkWrap: true,
              primary: false,
              padding: const EdgeInsets.all(10.0),
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              children: <Widget>[
                CustomDashboardButton(
                    onTap: () => AppNavigation.navigateTo(
                        AppNavRoutes.studentProfileRoute),
                    imageName: 'profile_icon.png'),
                CustomDashboardButton(
                    onTap: () => AppNavigation.navigateTo(
                        AppNavRoutes.academicTermRoute),
                    imageName: 'result_icon.png'),
                CustomDashboardButton(
                    onTap: () =>
                        AppNavigation.navigateTo(AppNavRoutes.libraryRoute),
                    imageName: 'diary_icon.png'),
                CustomDashboardButton(
                    onTap: () => AppNavigation.navigateTo(
                        AppNavRoutes.notificationsRoute),
                    imageName: 'notification_icon.png'),

                CustomDashboardButton(
                    onTap: () => AppNavigation.navigateTo(
                        AppNavRoutes.studentDiaryRoute),
                    imageName: 'diary_icon.png'),

                CustomDashboardButton(
                    onTap: () =>
                        AppNavigation.navigateTo(AppNavRoutes.feeChallansRoute),
                    imageName: 'feechallan_icon.png'),
                CustomDashboardButton(
                    onTap: () =>
                        AppNavigation.navigateTo(AppNavRoutes.attendanceRoute),
                    imageName: 'attendance_icon.png'),
              ]));
    });
  }
}

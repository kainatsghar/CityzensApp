import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Components/DashboardComponents/navigational_drawer.dart';
import 'package:tcs_app/CustomWidgets/CustomAppbar/custom_appbar.dart';
import 'package:tcs_app/CustomWidgets/CustomDashboardButton/custom_dashboard_button.dart';
import 'package:tcs_app/Provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Routes/app_navigation_routes.dart';

class StudentDashboardScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StudentDashboardScreenState();
  }
}

class StudentDashboardScreenState extends State<StudentDashboardScreen>
    with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return Consumer<LocalDataProvider>(builder: (context, value, _) {
      return Scaffold(
          appBar: CustomAppBar(title: 'Cityzens'),
          drawer:
              value.userData.userType == 'Parent' ? null : NavigationalDrawer(),
          body: GridView.count(
              shrinkWrap: true,
              primary: false,
              padding: const EdgeInsets.all(30.0),
              crossAxisSpacing: 15.0,
              mainAxisSpacing: 15.0,
              crossAxisCount: 2,
              children: <Widget>[
                CustomDashboardButton(
                    buttonTitle: 'Profile',
                    onTap: () => AppNavigation.navigateTo(
                        AppNavRoutes.studentProfileRoute),
                    imageName: 'profile.png'),
                CustomDashboardButton(
                    buttonTitle: 'Results',
                    onTap: () => AppNavigation.navigateTo(
                        AppNavRoutes.academicTermRoute),
                    imageName: 'result.png'),
                CustomDashboardButton(
                    buttonTitle: 'library',
                    onTap: () =>
                        AppNavigation.navigateTo(AppNavRoutes.libraryRoute),
                    imageName: 'library.png'),
                CustomDashboardButton(
                    buttonTitle: 'Notifications',
                    onTap: () => AppNavigation.navigateTo(
                        AppNavRoutes.notificationsRoute),
                    imageName: 'notification.png'),
                CustomDashboardButton(
                    buttonTitle: 'Fee Challans',
                    onTap: () =>
                        AppNavigation.navigateTo(AppNavRoutes.feeChallansRoute),
                    imageName: 'feechallan.png'),
                CustomDashboardButton(
                    buttonTitle: 'Attendance',
                    onTap: () =>
                        AppNavigation.navigateTo(AppNavRoutes.attendanceRoute),
                    imageName: 'attendance.png'),
                CustomDashboardButton(
                    buttonTitle: 'Diary',
                    onTap: () => AppNavigation.navigateTo(
                        AppNavRoutes.studentDiaryRoute),
                    imageName: 'diary.png')
              ]));
    });
  }
}

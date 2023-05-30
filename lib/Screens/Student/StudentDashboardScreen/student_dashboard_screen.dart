import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Components/DashboardComponents/navigational_drawer.dart';
import 'package:tcs_app/CustomWidgets/CustomAppbar/custom_appbar.dart';
import 'package:tcs_app/CustomWidgets/CustomDashboardButton/custom_dashboard_button.dart';
import 'package:tcs_app/Provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Routes/app_navigation_routes.dart';
import 'package:tcs_app/Services/FCMTokenRefresh/fcm_token_refresh_service.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../../Utils/app_colors.dart';

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
    Size size = MediaQuery.of(context).size;
    return Consumer<LocalDataProvider>(builder: (context, value, _) {
      return Scaffold(
          appBar: CustomAppBar(title: 'CITYZENS'),
          drawer:
              value.userData.userType == 'Parent' ? null : NavigationalDrawer(),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
            child: Column(
              children: [
                Container(
                    height: size.height * 0.2,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        '${DateFormat.MMMM().format(DateTime.now()).toUpperCase()}',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            color: AppColors.secondaryColor)),
                                    Text('${DateTime.now().year}',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            color: AppColors.whiteColor,
                                            fontWeight: FontWeight.w600))
                                  ]),
                              Text('MY\nATTENDANCE',
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color: AppColors.whiteColor,
                                      fontWeight: FontWeight.w600))
                            ],
                          ),
                          CircularPercentIndicator(
                              radius: size.width * 0.15,
                              lineWidth: 10.0,
                              percent: 0.75,
                              progressColor: Colors.green,
                              center: Text("75%",
                                  style: TextStyle(
                                      color: AppColors.whiteColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22.0)),
                              rotateLinearGradient: true,
                              circularStrokeCap: CircularStrokeCap.round)
                        ])),
                SizedBox(height: size.height * 0.02),
                Expanded(
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
                                AppNavRoutes.studentProfileRoute),
                            imageName: 'profile_icon.png'),
                        CustomDashboardButton(
                            title: 'RESULT\nCARD',
                            leftAlign: 5.0,
                            onTap: () => AppNavigation.navigateTo(
                                AppNavRoutes.academicTermRoute),
                            imageName: 'result_icon.png'),
                        CustomDashboardButton(
                            title: 'LIBRARY\nDETAILS',
                            bottomAlign: -28,
                            imageHeight: size.height * 0.14,
                            onTap: () => AppNavigation.navigateTo(
                                AppNavRoutes.libraryRoute),
                            imageName: 'library_icon.png'),
                        CustomDashboardButton(
                            title: 'NOTIFICATIONS',
                            leftAlign: 3.0,
                            bottomAlign: -3,
                            imageHeight: size.height * 0.1,
                            onTap: () => AppNavigation.navigateTo(
                                AppNavRoutes.notificationsRoute),
                            imageName: 'notification_icon.png'),
                        CustomDashboardButton(
                            title: 'HOMEWORK\nDIARY',
                            bottomAlign: -20,
                            leftAlign: -10,
                            onTap: () => AppNavigation.navigateTo(
                                AppNavRoutes.studentDiaryRoute),
                            imageName: 'diary_icon.png'),
                        CustomDashboardButton(
                            title: 'FEE\nCHALLANS',
                            bottomAlign: -22,
                            leftAlign: -12,
                            onTap: () => AppNavigation.navigateTo(
                                AppNavRoutes.feeChallansRoute),
                            imageName: 'fee_challan_icon.png'),
                        CustomDashboardButton(
                            title: 'ATTENDANCE',
                            bottomAlign: -22,
                            imageHeight: size.height * 0.13,
                            onTap: () => AppNavigation.navigateTo(
                                AppNavRoutes.attendanceRoute),
                            imageName: 'attendance_icon.png'),
                      ]),
                ),
              ],
            ),
          ));
    });
  }
}

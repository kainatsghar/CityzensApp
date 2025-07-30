import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Components/DashboardComponents/navigational_drawer.dart';
import 'package:tcs_app/CustomWidgets/CustomAppBar/custom_app_bar.dart';
import 'package:tcs_app/CustomWidgets/CustomDashboardButton/custom_dashboard_button.dart';
import 'package:tcs_app/Provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/Provider/StudentAttendance/student_attendance_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Routes/app_navigation_routes.dart';
import 'package:tcs_app/Routes/screen_arguments.dart';
import 'package:tcs_app/Services/FCMTokenRefresh/fcm_token_refresh_service.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../../CustomWidgets/CustomLoader/custom_loader.dart';
import '../../../Utils/app_colors.dart';
import '../../../Utils/helper_function.dart';

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
  var localData = Provider.of<LocalDataProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );
  var attendance = Provider.of<StudentAttendanceProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );
  late Future attendanceService;

  @override
  void initState() {
    if (localData.userData!.userType != 'Parent') {
      FcmTokenRefreshService.refreshToken();
    }
    attendanceService = attendance.getAttendancePercentage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    final double itemHeight = (size.height - kToolbarHeight - 24) / 6;
    final double itemWidth = size.width / 2;

    return Consumer<LocalDataProvider>(
      builder: (context, value, _) {
        final gradeId = value.userData?.info?.gradeId?.toString() ?? '';
        final localGradeId = value.gradeId?.toString() ?? '';
        return Scaffold(
          appBar: CustomAppBar(
            title: localData.userData!.userType == 'Parent'
                ? '${widget.args!.userName}'
                // ? '${widget.args.userName}'
                : HelperFunction.noNullStringText(
                    '${localData.userData!.info!.name}',
                  ),
          ),
          drawer: value.userData!.userType == 'Parent'
              ? null
              : const NavigationalDrawer(),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0,
            ),
            child: Column(
              children: [
                AttendanceDashboardCard(
                  size: size,
                  attendanceService: attendanceService,
                ),
                SizedBox(height: size.height * 0.01),
                Expanded(
                  child: GridView.count(
                    primary: false,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    crossAxisCount: 2,
                    shrinkWrap: false,
                    childAspectRatio: (itemWidth / itemHeight),
                    children: <Widget>[
                      CustomDashboardButton(
                        title: 'PROFILE',
                        bottomAlign: -20,
                        onTap: () => AppNavigation.navigateTo(
                          AppNavRoutes.studentProfileRoute,
                        ),
                        imageName: 'profile_icon.png',
                      ),
                      if (gradeId != '2' &&
                          gradeId != '3' &&
                          gradeId != '4' &&
                          gradeId != '5' &&
                          gradeId != '6' &&
                          localGradeId != '2' &&
                          localGradeId != '3' &&
                          localGradeId != '4' &&
                          localGradeId != '5' &&
                          localGradeId != '6')
                        CustomDashboardButton(
                          title: 'RESULT',
                          leftAlign: 5.0,
                          onTap: () => AppNavigation.navigateTo(
                            AppNavRoutes.academicTermRoute,
                          ),
                          imageName: 'result_icon.png',
                        ),
                      CustomDashboardButton(
                        title: 'LIBRARY',
                        bottomAlign: -45,
                        imageHeight: size.height * 0.14,
                        onTap: () =>
                            AppNavigation.navigateTo(AppNavRoutes.libraryRoute),
                        imageName: 'library_icon.png',
                      ),
                      CustomDashboardButton(
                        title: 'CIRCULARS',
                        leftAlign: 3.0,
                        bottomAlign: -3,
                        imageHeight: size.height * 0.1,
                        onTap: () => AppNavigation.navigateTo(
                          AppNavRoutes.notificationsRoute,
                        ),
                        imageName: 'notification_icon.png',
                      ),
                      CustomDashboardButton(
                        title: 'HOMEWORK\nDIARY',
                        bottomAlign: -20,
                        leftAlign: -10,
                        onTap: () => AppNavigation.navigateTo(
                          AppNavRoutes.studentDiaryRoute,
                        ),
                        imageName: 'diary_icon.png',
                      ),
                      CustomDashboardButton(
                        title: 'ATTENDANCE',
                        bottomAlign: -25,
                        imageHeight: size.height * 0.13,
                        onTap: () {
                          if (gradeId == '19' ||
                              gradeId == '20' ||
                              localGradeId == '19' ||
                              localGradeId == '20') {
                            AppNavigation.navigateTo(
                              AppNavRoutes.attendanceSubjectRoute,
                            );
                          } else {
                            AppNavigation.navigateTo(
                              AppNavRoutes.attendanceRoute,
                            );
                          }
                        },
                        imageName: 'attendance_icon.png',
                      ),
                      CustomDashboardButton(
                        title: 'FEE BILL &\n PAYMENT',
                        bottomAlign: -25,
                        leftAlign: -12,
                        onTap: () => AppNavigation.navigateTo(
                          AppNavRoutes.feeChallansRoute,
                        ),
                        imageName: 'fee_challan_icon.png',
                      ),
                      CustomDashboardButton(
                        title: 'CLASSWORK\nASSIGNMENTS',
                        bottomAlign: -65,
                        leftAlign: -50,
                        imageHeight: size.height * 0.20,
                        onTap: () => AppNavigation.navigateTo(
                          AppNavRoutes.studentAssignmentRoute,
                        ),
                        imageName: 'assignment_icon_h.png',
                      ),
                      // CustomDashboardButton(
                      //     title: 'EVENT\nCALENDAR',
                      //     bottomAlign: -22,
                      //     leftAlign: -10,
                      //     imageHeight: size.height * 0.13,
                      //     onTap: () => AppNavigation.navigateTo(
                      //         AppNavRoutes.studentSchoolEventsRoute),
                      //     imageName: 'calendar.png'),
                      if (gradeId != '2' &&
                          gradeId != '3' &&
                          gradeId != '4' &&
                          gradeId != '5' &&
                          gradeId != '6' &&
                          localGradeId != '2' &&
                          localGradeId != '3' &&
                          localGradeId != '4' &&
                          localGradeId != '5' &&
                          localGradeId != '6')
                        CustomDashboardButton(
                          title: 'CLASS TEST\nRESULTS',
                          bottomAlign: -65,
                          leftAlign: -65,
                          imageHeight: size.height * 0.24,
                          onTap: () => AppNavigation.navigateTo(
                            AppNavRoutes.studentClassTestResultRoute,
                          ),
                          imageName: 'class_result.png',
                        ),
                      CustomDashboardButton(
                        title: 'TIMETABLE',
                        bottomAlign: -22,
                        leftAlign: -10,
                        imageHeight: size.height * 0.13,
                        onTap: () => AppNavigation.navigateTo(
                          AppNavRoutes.teacherTimeTableRoute,
                        ),
                        imageName: 'calendar.png',
                      ),
                      // CustomDashboardButton(
                      //     title: 'SURVEY',
                      //     bottomAlign: -14,
                      //     leftAlign: -10,
                      //     imageHeight: size.height * 0.11,
                      //     onTap: () => AppNavigation.navigateTo(
                      //         AppNavRoutes.studentSurveyRoute),
                      //     imageName: 'survey.png'),
                      // CustomDashboardButton(
                      //     title: 'INDIVIDUAL\nEDUCATION PLAN',
                      //     bottomAlign: -65,
                      //     leftAlign: -65,
                      //     imageHeight: size.height * 0.24,
                      //     onTap: () => AppNavigation.navigateTo(
                      //         AppNavRoutes.individualEducationPlanRoute),
                      //     imageName: 'class_result.png'),
                      // if (value.userData!.userType == 'Parent')
                      //   CustomDashboardButton(
                      //     title: 'BILL\nPAYMENT',
                      //     bottomAlign: -25,
                      //     leftAlign: -10,
                      //     onTap: () => AppNavigation.navigateTo(
                      //       AppNavRoutes.challanPaymentRoute,
                      //     ),
                      //     imageName: 'challan_payment_icon.png',
                      //   ),
                      // if (value.userData!.userType == 'Parent')
                      //   CustomDashboardButton(
                      //       title: 'BOOK AN\nAPPOINTMENT',
                      //       bottomAlign: -24,
                      //       leftAlign: 0,
                      //       imageHeight: size.height * 0.10,
                      //       onTap: () => AppNavigation.navigateTo(
                      //           AppNavRoutes.bookanAppointmentRoute),
                      //       imageName: 'calendar_appoointment.png'),
                      if ((gradeId == '2' ||
                              gradeId == '3' ||
                              gradeId == '4' ||
                              localGradeId == '2' ||
                              localGradeId == '3' ||
                              localGradeId == '4') &&
                          value.userData!.userType == 'Parent')
                        CustomDashboardButton(
                          title: 'EYE ON\nYOUR CHILD',
                          bottomAlign: -22,
                          leftAlign: 0,
                          imageHeight: size.height * 0.10,
                          onTap: () => AppNavigation.navigateTo(
                            AppNavRoutes.parentEyeOnYourChildRoute,
                          ),
                          imageName: 'shield.png',
                        ),
                      // if (value.userData!.userType == 'Parent')
                      //   CustomDashboardButton(
                      //       title: 'WITHDRAWAL\nREQUEST',
                      //       bottomAlign: -22,
                      //       leftAlign: -15, //0,
                      //       imageHeight: size.height * 0.08,
                      //       onTap: () => AppNavigation.navigateTo(
                      //           AppNavRoutes.withdrawalRequestRoute),
                      //       imageName: 'withdrawal.png'),
                      // if (value.userData!.userType == 'Parent')
                      //   CustomDashboardButton(
                      //       title: 'COMPLAINT\nQUERY',
                      //       bottomAlign: -20,
                      //       leftAlign: -15, //0,
                      //       imageHeight: size.height * 0.10,
                      //       onTap: null,
                      //       // () => AppNavigation.navigateTo(
                      //       //     AppNavRoutes.complaintQueryRoute),
                      //       imageName: 'lightbulb.png'),
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

class AttendanceDashboardCard extends StatelessWidget {
  const AttendanceDashboardCard({
    super.key,
    required this.size,
    required this.attendanceService,
  });

  final Size size;
  final Future attendanceService;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Container(
        height: size.height * 0.18,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(16.0),
        ),
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
                      DateFormat.MMMM().format(DateTime.now()).toUpperCase(),
                      style: const TextStyle(
                        fontSize: 18.0,
                        color: AppColors.secondaryColor,
                      ),
                    ),
                    Text(
                      '${DateTime.now().year}',
                      style: const TextStyle(
                        fontSize: 18.0,
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const Text(
                  'MY\nATTENDANCE',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            FutureBuilder(
              future: attendanceService,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: CustomLoader(color: AppColors.whiteColor),
                    );
                  default:
                    if (snapshot.hasData) {
                      return Consumer<StudentAttendanceProvider>(
                        builder: (context, value, _) {
                          num data = value
                              .attendancePercentage!
                              .data!
                              .attendancePercentage!;
                          return Card(
                            elevation: 4,
                            borderOnForeground: false,
                            color: Colors.transparent,
                            shadowColor: AppColors.blackColor.withValues(
                              alpha: 0.9,
                            ),
                            margin: EdgeInsets.zero,
                            shape: CircleBorder(),
                            child: CircularPercentIndicator(
                              radius: size.height * 0.07,
                              lineWidth: 10.0,
                              percent: data / 100,
                              progressColor: AppColors.successGreenColor,
                              backgroundColor: AppColors.whiteColor,
                              center: Text(
                                "$data%",
                                style: const TextStyle(
                                  color: AppColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22.0,
                                ),
                              ),
                              rotateLinearGradient: true,
                              circularStrokeCap: CircularStrokeCap.round,
                            ),
                          );
                        },
                      );
                    } else {
                      return const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Icon(
                          Icons.error_outline,
                          color: AppColors.lightRedColor,
                          size: 50,
                        ),
                      );
                    }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

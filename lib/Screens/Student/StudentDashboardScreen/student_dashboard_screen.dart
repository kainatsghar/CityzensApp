import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/components/DashboardComponents/navigational_drawer.dart';
import 'package:tcs_app/custom_widgets/CustomAppBar/custom_app_bar.dart';
import 'package:tcs_app/custom_widgets/CustomDashboardButton/custom_dashboard_button.dart';
import 'package:tcs_app/Provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/Provider/StudentAttendance/student_attendance_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Routes/app_navigation_routes.dart';
import 'package:tcs_app/Routes/screen_arguments.dart';
import 'package:tcs_app/Screens/Student/StudentDashboardScreen/update_dashboard_card.dart';
import 'package:tcs_app/Services/FCMTokenRefresh/fcm_token_refresh_service.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:tcs_app/Utils/media_query_util.dart';

import '../../../custom_widgets/CustomLoader/custom_loader.dart';
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
  // var dashboardProvider = Provider.of<DashboardProvider>(
  //   AppNavigation.currentContext!,
  //   listen: false,
  // );

  // final splashProvider = Provider.of<SplashProvider>(
  //   AppNavigation.currentContext!,
  //   listen: false,
  // );
  // bool isDashboardResultCardViewFeatureEnabled = false;
  // bool isAcademicResultPublishedFeatureEnable = false;

  Future? attendanceService;
  // Future? resultService;
  // bool isURLOpening = false;
  // FeatureConfigModel? academicResultPublishedFeature;

  @override
  void initState() {
    if (localData.userData!.userType != 'Parent') {
      FcmTokenRefreshService.refreshToken();
    }
    attendanceService = attendance.getAttendancePercentage();

    // if (splashProvider.listOfFeatureConfig != null) {
    //   try {
    //     academicResultPublishedFeature = splashProvider.listOfFeatureConfig!
    //         .firstWhere((feature) => feature.id == 'academicResultPublished');

    //     if (academicResultPublishedFeature == null) {
    //       isAcademicResultPublishedFeatureEnable = false;
    //     } else {
    //       isAcademicResultPublishedFeatureEnable =
    //           academicResultPublishedFeature!.isActive;
    //     }
    //   } catch (e) {
    //     isAcademicResultPublishedFeatureEnable = false;
    //   }
    //   try {
    //     final dashboardResultCardViewFeature = splashProvider
    //         .listOfFeatureConfig!
    //         .firstWhere((feature) => feature.id == 'dashboardResultCardView');

    //     isDashboardResultCardViewFeatureEnabled =
    //         dashboardResultCardViewFeature.isActive;
    //   } catch (e) {
    //     isDashboardResultCardViewFeatureEnabled = false;
    //   }
    // }

    // if (isDashboardResultCardViewFeatureEnabled) {
    //   resultService = dashboardProvider.loadResults(
    //     academicYearId: 17,
    //     termId: 1,
    //   );
    // }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final double itemHeight =
        ((MediaQueryUtil.isLandscape() ? size.width : size.height) -
            kToolbarHeight -
            24) /
        6;
    final double itemWidth =
        (MediaQueryUtil.isLandscape() ? size.height : size.width) / 2;

    return Consumer<LocalDataProvider>(
      builder: (context, value, _) {
        final gradeId = value.userData?.info?.gradeId?.toString() ?? '';
        final localGradeId = value.gradeId?.toString() ?? '';
        // print('GRADE ID DASHBOARD: $gradeId');
        // print('LOCAL GRADE ID DASHBOARD: $localGradeId');
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
          body: RefreshIndicator(
            onRefresh: () {
              return attendanceService = attendance.getAttendancePercentage();
            },
            child: SafeArea(
              top: false,
              child: CustomScrollView(
                slivers: [
                  // SliverToBoxAdapter(
                  //   child: Padding(
                  //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  //     child: AttendanceDashboardCard(
                  //       attendanceService: attendanceService,
                  //       size: size,
                  //     ),
                  //   ),
                  // ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: DashboardTopSection(
                        showResult: false,
                        // (gradeId != '2' &&
                        // gradeId != '3' &&
                        // gradeId != '4' &&
                        // localGradeId != '2' &&
                        // localGradeId != '3' &&
                        // localGradeId != '4' &&
                        // isDashboardResultCardViewFeatureEnabled),
                        resultReleaseTime:
                            // academicResultPublishedFeature?.startDate ??
                            DateTime(2025, 12, 22, 17, 12, 0),
                        onViewResult: null,
                        //  !isAcademicResultPublishedFeatureEnable
                        //     ? null
                        //     : () async {
                        //         final url =
                        //             dashboardProvider
                        //                         .resultsResponse
                        //                         .pdfResultslist !=
                        //                     null &&
                        //                 dashboardProvider
                        //                     .resultsResponse
                        //                     .pdfResultslist!
                        //                     .isNotEmpty
                        //             ? dashboardProvider
                        //                   .resultsResponse
                        //                   .pdfResultslist![0]
                        //                   .url!
                        //             : '';
                        //         if (url.isNotEmpty) {
                        //           if (!isURLOpening) {
                        //             isURLOpening = true;
                        //             await HelperFunction.launchURL(url);
                        //             FirebaseAnalytics.instance.logEvent(
                        //               name: 'view_result_from_dashboard',
                        //               parameters: {
                        //                 'student_id': localData.studentId,
                        //                 'grade_id': localData.gradeId
                        //                     .toString(),
                        //               },
                        //             );
                        //             isURLOpening = false;
                        //           }
                        //         }
                        //       },
                        attendanceService: attendanceService!,
                        resultService: null,
                        // resultService,
                        size: size,
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                    sliver: SliverGrid.count(
                      crossAxisCount: 2,
                      childAspectRatio: itemWidth / itemHeight,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      children: [
                        CustomDashboardButton(
                          title: 'PROFILE',
                          bottomAlign: -20,
                          onTap: () => AppNavigation.navigateTo(
                            AppNavRoutes.studentProfileRoute,
                          ),
                          imageName: 'profile_icon.png',
                        ),
                        CustomDashboardButton(
                          title: 'ATTENDANCE',
                          bottomAlign: -25,
                          imageHeight:
                              MediaQueryUtil.getResponsivePercentageSize(13),
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
                          title: 'HOMEWORK\nDIARY',
                          bottomAlign: -20,
                          leftAlign: -10,
                          onTap: () => AppNavigation.navigateTo(
                            AppNavRoutes.studentDiaryRoute,
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
                            AppNavRoutes.studentAssignmentRoute,
                          ),
                          imageName: 'assignment_icon_h.png',
                        ),
                        if (gradeId != '2' &&
                            gradeId != '3' &&
                            gradeId != '4' &&
                            // gradeId != '5' &&
                            // gradeId != '6' &&
                            localGradeId != '2' &&
                            localGradeId != '3' &&
                            localGradeId != '4'
                        // &&
                        // localGradeId != '5' &&
                        // localGradeId != '6'
                        )
                          CustomDashboardButton(
                            title: 'TERM RESULT',
                            leftAlign: 5.0,
                            onTap: () => AppNavigation.navigateTo(
                              AppNavRoutes.academicTermRoute,
                            ),
                            imageName: 'result_icon.png',
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
                            title: 'CLASS TEST\nRESULTS',
                            bottomAlign: -65,
                            leftAlign: -65,
                            imageHeight:
                                MediaQueryUtil.getResponsivePercentageSize(24),
                            onTap: () => AppNavigation.navigateTo(
                              AppNavRoutes.studentClassTestResultRoute,
                            ),
                            imageName: 'class_result.png',
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
                          title: 'CIRCULARS',
                          leftAlign: 3.0,
                          bottomAlign: -3,
                          imageHeight:
                              MediaQueryUtil.getResponsivePercentageSize(10),
                          onTap: () => AppNavigation.navigateTo(
                            AppNavRoutes.notificationsRoute,
                          ),
                          imageName: 'notification_icon.png',
                        ),
                        CustomDashboardButton(
                          title: 'LIBRARY',
                          bottomAlign: -45,
                          imageHeight:
                              MediaQueryUtil.getResponsivePercentageSize(14),
                          onTap: () => AppNavigation.navigateTo(
                            AppNavRoutes.libraryRoute,
                          ),
                          imageName: 'library_icon.png',
                        ),

                        CustomDashboardButton(
                          title: 'TIMETABLE',
                          bottomAlign: -22,
                          leftAlign: -10,
                          imageHeight:
                              MediaQueryUtil.getResponsivePercentageSize(13),
                          onTap: () => AppNavigation.navigateTo(
                            AppNavRoutes.teacherTimeTableRoute,
                          ),
                          imageName: 'calendar.png',
                        ),
                        // CustomDashboardButton(
                        //     title: 'EVENT\nCALENDAR',
                        //     bottomAlign: -22,
                        //     leftAlign: -10,
                        //     imageHeight: MediaQueryUtil.getResponsivePercentageSize(13),
                        //     onTap: () => AppNavigation.navigateTo(
                        //         AppNavRoutes.studentSchoolEventsRoute),
                        //     imageName: 'calendar.png'),

                        // CustomDashboardButton(
                        //     title: 'SURVEY',
                        //     bottomAlign: -14,
                        //     leftAlign: -10,
                        //     imageHeight: MediaQueryUtil.getResponsivePercentageSize(11),
                        //     onTap: () => AppNavigation.navigateTo(
                        //         AppNavRoutes.studentSurveyRoute),
                        //     imageName: 'survey.png'),
                        // CustomDashboardButton(
                        //     title: 'INDIVIDUAL\nEDUCATION PLAN',
                        //     bottomAlign: -65,
                        //     leftAlign: -65,
                        //     imageHeight: MediaQueryUtil.getResponsivePercentageSize(24),
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
                        //       imageHeight: MediaQueryUtil.getResponsivePercentageSize(10),
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
                            imageHeight:
                                MediaQueryUtil.getResponsivePercentageSize(10),
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
                        //       imageHeight: MediaQueryUtil.getResponsivePercentageSize(8),
                        //       onTap: () => AppNavigation.navigateTo(
                        //           AppNavRoutes.withdrawalRequestRoute),
                        //       imageName: 'withdrawal.png'),
                        // if (value.userData!.userType == 'Parent')
                        //   CustomDashboardButton(
                        //       title: 'COMPLAINT\nQUERY',
                        //       bottomAlign: -20,
                        //       leftAlign: -15, //0,
                        //       imageHeight: MediaQueryUtil.getResponsivePercentageSize(10),
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
    this.attendanceService,
  });

  final Size size;
  final Future? attendanceService;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Container(
        // height: MediaQueryUtil.getResponsivePercentageSize(18),
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
                        height: 1,
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
                    height: 1.12,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQueryUtil.getResponsivePercentageSize(18) - 32,
              child: FutureBuilder(
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
                            num data =
                                value
                                    .attendancePercentage!
                                    .data!
                                    .attendancePercentage ??
                                0;
                            data = data.clamp(0, 100);
                            return Card(
                              elevation: 4,
                              borderOnForeground: false,
                              color: Colors.transparent,
                              shadowColor: AppColors.blackColor.withValues(
                                alpha: 0.9,
                              ),
                              margin: EdgeInsets.zero,
                              shape: const CircleBorder(),
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  // compute radius based on available height/width
                                  final double maxDiameter =
                                      constraints.biggest.shortestSide;
                                  final double radius = (maxDiameter * 0.8) / 2;
                                  final double lineWidth = (maxDiameter / 20)
                                      .clamp(3.0, 12.0);
                                  final double fontSize = (radius * 0.45).clamp(
                                    12.0,
                                    24.0,
                                  );

                                  return SizedBox(
                                    width: maxDiameter,
                                    height: maxDiameter,
                                    child: CircularPercentIndicator(
                                      radius: radius,
                                      lineWidth: lineWidth,
                                      percent: data / 100,
                                      progressColor:
                                          AppColors.successGreenColor,
                                      backgroundColor: AppColors.whiteColor,
                                      center: Text(
                                        "${data == 100 ? "100" : data}%",
                                        style: TextStyle(
                                          color: AppColors.whiteColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: fontSize,
                                        ),
                                      ),
                                      rotateLinearGradient: true,
                                      circularStrokeCap:
                                          CircularStrokeCap.round,
                                    ),
                                  );
                                },
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
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardTopSection extends StatefulWidget {
  final bool showResult;
  final DateTime resultReleaseTime;
  final void Function()? onViewResult;
  final Future<dynamic>? resultService;
  final Future? attendanceService;
  final Size size;

  const DashboardTopSection({
    super.key,
    required this.showResult,
    required this.resultReleaseTime,
    required this.onViewResult,
    this.resultService,
    this.attendanceService,
    required this.size,
  });

  @override
  State<DashboardTopSection> createState() => _DashboardTopSectionState();
}

class _DashboardTopSectionState extends State<DashboardTopSection> {
  int _activeIndex = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double cardHeight = MediaQueryUtil.getResponsivePercentageSize(
      20,
    ).clamp(150.0, 175.0);

    if (!widget.showResult) {
      return SizedBox(
        height: cardHeight,
        child: DashboardCardWrapper(
          child: AttendanceDashboardCard(
            attendanceService: widget.attendanceService,
            size: widget.size,
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: cardHeight,
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _activeIndex = index),
            children: [
              // Result card
              DashboardCardWrapper(
                child: ResultDashboardCard(
                  resultReleaseTime: widget.resultReleaseTime,
                  onViewResult: widget.onViewResult,
                  loadResultsFuture: widget.resultService,
                ),
              ),

              // Attendance card
              DashboardCardWrapper(
                child: AttendanceDashboardCard(
                  attendanceService: widget.attendanceService,
                  size: widget.size,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        CarouselDots(
          count: 2,
          activeIndex: _activeIndex,
          onDotTapped: (index) {
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
        ),
      ],
    );
  }
}

class CarouselDots extends StatelessWidget {
  final int count;
  final int activeIndex;
  final void Function(int)? onDotTapped;

  const CarouselDots({
    super.key,
    required this.count,
    required this.activeIndex,
    this.onDotTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = activeIndex == index;
        final dot = AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 10 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primaryColor : Colors.grey.shade400,
            borderRadius: BorderRadius.circular(60),
          ),
        );

        if (onDotTapped != null) {
          return GestureDetector(onTap: () => onDotTapped!(index), child: dot);
        }
        return dot;
      }),
    );
  }
}

class DashboardCardWrapper extends StatelessWidget {
  final Widget child;

  const DashboardCardWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}

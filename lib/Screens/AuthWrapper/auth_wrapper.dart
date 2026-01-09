import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/CustomWidgets/ShowError/show_error.dart';
import 'package:tcs_app/Provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/Provider/Splash/splash_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Screens/LoginScreen/login_screen.dart';
import 'package:tcs_app/Screens/Parent/ParentDashboardScreen/parent_dashboard_screen.dart';
import 'package:tcs_app/Screens/Student/StudentDashboardScreen/student_dashboard_screen.dart';
import 'package:tcs_app/Screens/Teacher/TeacherDashboardScreen/teacher_dashboard_screen.dart';
import 'package:tcs_app/Utils/app_constants.dart';
import 'package:upgrader/upgrader.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    authDecider();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: FutureBuilder(
        future: authDecider(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const CustomLoader();
            default:
              if (snapshot.hasData) {
                return snapshot.data as Widget; //return snapshot.data
              } else {
                return ShowError(errorText: '${snapshot.error}');
              }
          }
        },
      ),
    );
  }

  Future<Widget> authDecider() async {
    final localDataProvider = Provider.of<LocalDataProvider>(
      AppNavigation.currentContext!,
      listen: false,
    );
    final splashProvider = Provider.of<SplashProvider>(
      AppNavigation.currentContext!,
      listen: false,
    );
    bool isTeacherForceLoginFeatureAvailable = false;

    if (splashProvider.listOfFeatureConfig != null) {
      try {
        final teacherForceLoginFeature = splashProvider.listOfFeatureConfig!
            .firstWhere((feature) => feature.id == 'teacherForceLogin');

        isTeacherForceLoginFeatureAvailable =
            (kReleaseMode && teacherForceLoginFeature.isLive) ||
            (kDebugMode && teacherForceLoginFeature.isTesting);
      } catch (e) {
        isTeacherForceLoginFeatureAvailable = false;
      }
    }

    final userData = await localDataProvider.loadStoredData(
      teacherForceLogIn: isTeacherForceLoginFeatureAvailable,
    );
    return kIsWeb
        ? (userData.tokenId == null)
              ? const LoginScreen()
              : (userData.userType == 'Student')
              ? const StudentDashboardScreen()
              : (userData.userType == 'Teacher')
              ? const TeacherDashboardScreen()
              : const ParentDashboardScreen()
        : UpgradeAlert(
            barrierDismissible: true,
            upgrader: Upgrader(minAppVersion: AppConstants.appVersion),
            showLater: true,
            showIgnore: false,
            dialogStyle: Platform.isIOS
                ? UpgradeDialogStyle.cupertino
                : UpgradeDialogStyle.material,
            navigatorKey: AppNavigation.navigatorKey,
            child: (userData.tokenId == null)
                ? const LoginScreen()
                : (userData.userType == 'Student')
                ? const StudentDashboardScreen()
                : (userData.userType == 'Teacher')
                ? const TeacherDashboardScreen()
                : const ParentDashboardScreen(),
          );
  }
}

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/ShimmerEffect/dashboard_shimmer.dart';
import 'package:tcs_app/custom_widgets/ShowError/show_error.dart';
import 'package:tcs_app/provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/routes/app_navigation.dart';
import 'package:tcs_app/screens/LoginScreen/login_screen.dart';
import 'package:tcs_app/screens/Student/StudentDashboardScreen/student_dashboard_screen.dart';
import 'package:tcs_app/screens/Teacher/TeacherDashboardScreen/teacher_dashboard_screen.dart';
import 'package:tcs_app/utils/app_colors.dart';
import 'package:tcs_app/utils/app_constants.dart';
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.4, 1.0],
            colors: [
              AppColors.whiteColor,
              Color(0xFFF8FAFC),
              Color(0xFFF1F5F9),
            ],
          ),
        ),
        child: FutureBuilder(
          future: authDecider(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      SizedBox(height: 60),
                      DashboardShimmer(itemCount: 4),
                    ],
                  ),
                );
              default:
                if (snapshot.hasData) {
                  return snapshot.data as Widget;
                } else {
                  return ShowError(errorText: '${snapshot.error}');
                }
            }
          },
        ),
      ),
    );
  }

  Future<Widget> authDecider() async {
    final localDataProvider = Provider.of<LocalDataProvider>(
      AppNavigation.currentContext!,
      listen: false,
    );

    final userData = await localDataProvider.loadStoredData();
    return kIsWeb
        ? (userData.tokenId == null)
              ? const LoginScreen()
              : (userData.userType == 'Student')
              ? const StudentDashboardScreen()
              : (userData.userType == 'Teacher')
              ? const TeacherDashboardScreen()
              : const StudentDashboardScreen()
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
                : const StudentDashboardScreen(),
          );
  }
}

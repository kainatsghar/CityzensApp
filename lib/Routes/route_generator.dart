import 'package:flutter/material.dart';
import 'package:tcs_app/CustomWidgets/CustomAppbar/custom_appbar.dart';
import 'package:tcs_app/PushNotifications/push_notifications.dart';
import 'package:tcs_app/Routes/app_navigation_routes.dart';
import 'package:tcs_app/Screens/AppFeedbackScreen/app_feedback_screen.dart';
import 'package:tcs_app/Screens/AuthWrapper/auth_wrapper.dart';
import 'package:tcs_app/Screens/Feechallans/fee_challans_screen.dart';
import 'package:tcs_app/Screens/ForgotPasswordScreen/forgot_password_screen.dart';
import 'package:tcs_app/Screens/CreatePasswordScreen/create_password_screen.dart';
import 'package:tcs_app/Screens/AboutAppScreen/about_app_screen.dart';
import 'package:tcs_app/Screens/AboutUsScreen/about_us_screen.dart';
import 'package:tcs_app/Screens/ChangePasswordScreen/change_password_screen.dart';
import 'package:tcs_app/Screens/LibraryScreen/library_screen.dart';
import 'package:tcs_app/Screens/Notifications/notifications_screen.dart';
import 'package:tcs_app/Screens/OSRegistrationScreen/os_registration_screen.dart';
import 'package:tcs_app/Screens/ParentDashboardScreen/parent_dashboard_screen.dart';
import 'package:tcs_app/Screens/RegistrationScreen/registration_screen.dart';
import 'package:tcs_app/Screens/RegPinCodeScreen/reg_pincode_screen.dart';
import 'package:tcs_app/Screens/Results/academic_term_screen.dart';
import 'package:tcs_app/Screens/Results/results_screen.dart';
import 'package:tcs_app/Screens/StudentDashboardScreen/student_dashboard_screen.dart';
import 'package:tcs_app/Screens/StudentProfileScreen/student_profile_screen.dart';
import 'package:tcs_app/Screens/TeacherSectionScreen/teacher_section_screen.dart';
import 'package:tcs_app/Screens/UpdatePasswordScreen/update_password_screen.dart';
import 'package:tcs_app/Screens/ForgotPinCodeScreen/forgot_pincode_screen.dart';
import 'package:tcs_app/Screens/LoginScreen/login_screen.dart';
import 'package:tcs_app/Screens/SplashScreen/splash_screen_ui.dart';
import 'package:tcs_app/Screens/AttendanceListScreen/attendance_list_screen.dart';
import 'package:tcs_app/Screens/TeacherDashboardScreen/teacher_dashboard_screen.dart';
import 'package:tcs_app/Screens/TeacherProfileScreen/teacher_profile_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppNavRoutes.initialRoute:
        return routeScreen(child: SplashScreenUI());
      case AppNavRoutes.loginRoute:
        return routeScreen(child: LoginScreen());
      case AppNavRoutes.authWrapperRoute:
        return routeScreen(
            child: PushNotificationsManager(child: AuthWrapper()));
      case AppNavRoutes.registrationRoute:
        return routeScreen(child: RegistrationScreen());
      case AppNavRoutes.forgotPinCodeRoute:
        return routeScreen(child: ForgotPinCodeScreen());
      case AppNavRoutes.registrationPinCodeRoute:
        return routeScreen(child: RegPinCodeScreen());
      case AppNavRoutes.createPasswordRoute:
        return routeScreen(child: CreatePasswordScreen());
      case AppNavRoutes.studentDashboardRoute:
        return routeScreen(child: StudentDashboardScreen());
      case AppNavRoutes.parentDashboardRoute:
        return routeScreen(child: ParentDashboardScreen());
      case AppNavRoutes.studentProfileRoute:
        return routeScreen(child: StudentProfileScreen());
      case AppNavRoutes.academicTermRoute:
        return routeScreen(child: AcademicTermScreen());
      case AppNavRoutes.resultsRoute:
        return routeScreen(child: ResultsScreen());
      case AppNavRoutes.libraryRoute:
        return routeScreen(child: LibraryScreen());
      case AppNavRoutes.notificationsRoute:
        return routeScreen(child: NotificationScreen());
      case AppNavRoutes.feeChallansRoute:
        return routeScreen(child: FeeChallanScreen());
      case AppNavRoutes.teacherDashboardRoute:
        return routeScreen(child: TeacherDashboardScreen());
      case AppNavRoutes.teacherProfileRoute:
        return routeScreen(child: TeacherProfileScreen());
      case AppNavRoutes.attendanceRoute:
        return routeScreen(child: AttendanceListScreen());
      case AppNavRoutes.onlineStdRegRoute:
        return routeScreen(child: OSRegistrationScreen());
      case AppNavRoutes.forgotPasswordRoute:
        return routeScreen(child: ForgotPasswordScreen());
      case AppNavRoutes.updatePasswordRoute:
        return routeScreen(child: UpdatePasswordScreen());
      case AppNavRoutes.aboutUsRoute:
        return routeScreen(child: AboutUsScreen());
      case AppNavRoutes.appFeedbackRoute:
        return routeScreen(child: AppFeedbackScreen());
      case AppNavRoutes.aboutAppRoute:
        return routeScreen(child: AboutAppScreen());
      case AppNavRoutes.changePasswordRoute:
        return routeScreen(child: ChangePasswordScreen());
      case AppNavRoutes.teacherSectionRoute:
        return routeScreen(child: TeacherSectionScreen());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
          appBar: CustomAppBar(title: 'Error'),
          body: Center(child: Text('ERROR')));
    });
  }

  static Route<dynamic> routeScreen(
      {Widget child, bool fullscreenDialog = false}) {
    return MaterialPageRoute(
        builder: (context) => child, fullscreenDialog: fullscreenDialog);
  }
}

import 'package:flutter/material.dart';
import 'package:tcs_app/CustomWidgets/CustomAppbar/custom_appbar.dart';
import 'package:tcs_app/PushNotifications/push_notifications.dart';
import 'package:tcs_app/Routes/app_navigation_routes.dart';
import 'package:tcs_app/Screens/AuthWrapper/auth_wrapper.dart';
import 'package:tcs_app/Screens/LoginScreen/login_screen.dart';
import 'package:tcs_app/Screens/SplashScreen/splash_screen_ui.dart';
import 'package:tcs_app/Screens/Teacher/AddDiaryScreen/add_diary_screen.dart';
import 'package:tcs_app/Screens/Teacher/MarkUnverifiedScreen/mark_unverified_screen.dart';
import 'package:tcs_app/Screens/Teacher/TeacherDiaryScreen/teacher_diary_screen.dart';
import '../Screens/ForgotPassword/ForgotPasswordScreen/forgot_password_screen.dart';
import '../Screens/ForgotPassword/ForgotPinCodeScreen/forgot_pincode_screen.dart';
import '../Screens/ForgotPassword/UpdatePasswordScreen/update_password_screen.dart';
import '../Screens/NavigationalDrawer/AboutAppScreen/about_app_screen.dart';
import '../Screens/NavigationalDrawer/AboutUsScreen/about_us_screen.dart';
import '../Screens/NavigationalDrawer/AppFeedbackScreen/app_feedback_screen.dart';
import '../Screens/NavigationalDrawer/ChangePasswordScreen/change_password_screen.dart';
import '../Screens/Parent/ParentDashboardScreen/parent_dashboard_screen.dart';
import '../Screens/Registration/CreatePasswordScreen/create_password_screen.dart';
import '../Screens/Registration/RegPinCodeScreen/reg_pincode_screen.dart';
import '../Screens/Registration/RegistrationScreen/registration_screen.dart';
import '../Screens/Student/Feechallans/fee_challans_screen.dart';
import '../Screens/Student/LibraryScreen/library_screen.dart';
import '../Screens/Student/Notifications/notifications_screen.dart';
import '../Screens/Student/OSRegistrationScreen/os_registration_screen.dart';
import '../Screens/Student/ResultScreen/academic_term_screen.dart';
import '../Screens/Student/ResultScreen/results_screen.dart';
import '../Screens/Student/StudentAttendanceScreen/student_attendance_screen.dart';
import '../Screens/Student/StudentDashboardScreen/student_dashboard_screen.dart';
import '../Screens/Student/StudentProfileScreen/student_profile_screen.dart';
import '../Screens/Teacher/AttendanceListScreen/attendance_list_screen.dart';
import '../Screens/Teacher/TeacherDashboardScreen/teacher_dashboard_screen.dart';
import '../Screens/Teacher/TeacherProfileScreen/teacher_profile_screen.dart';
import '../Screens/Teacher/TeacherSectionScreen/teacher_section_screen.dart';

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
      case AppNavRoutes.markAttendanceRoute:
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
      case AppNavRoutes.attendanceRoute:
        return routeScreen(child: StudentAttendanceScreen());
      case AppNavRoutes.markUnverifiedRoute:
        return routeScreen(child: MarkUnverifiedScreen());
      case AppNavRoutes.addDiaryRoute:
        return routeScreen(child: AddDiaryScreen());
      case AppNavRoutes.teacherDiaryRoute:
        return routeScreen(child: TeacherDiaryScreen());
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

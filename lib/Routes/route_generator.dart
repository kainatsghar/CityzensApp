import 'package:flutter/material.dart';
import 'package:tcs_app/CustomWidgets/CustomAppBar/custom_app_bar.dart';
import 'package:tcs_app/CustomWidgets/ShowError/show_error.dart';
import 'package:tcs_app/Routes/app_navigation_routes.dart';
import 'package:tcs_app/Routes/challan_args.dart';
import 'package:tcs_app/Routes/promotion_args.dart';
import 'package:tcs_app/Routes/screen_arguments.dart';
import 'package:tcs_app/Screens/AuthWrapper/auth_wrapper.dart';
import 'package:tcs_app/Screens/LoginScreen/login_screen.dart';
import 'package:tcs_app/Screens/Parent/ChallanPaymentScreen/challan_payment_screen.dart';
import 'package:tcs_app/Screens/Parent/WithdrawalRequestScreen/withdrawal_request_screen.dart';
import 'package:tcs_app/Screens/Promotion/promotion_screen_ui.dart';
import 'package:tcs_app/Screens/SplashScreen/splash_screen_ui.dart';
import 'package:tcs_app/Screens/Student/StudentAssignmentScreen/student_assignment_screen.dart';
import 'package:tcs_app/Screens/Student/StudentAttendanceScreen/student_alevel_attendance_screen.dart';
import 'package:tcs_app/Screens/Student/StudentAttendanceScreen/student_alevel_attendance_subject_screen.dart';
import 'package:tcs_app/Screens/Student/StudentClassTestResultScreen/student_class_result_screen.dart';
import 'package:tcs_app/Screens/Student/StudentDiaryScreen/student_diary_screen.dart';
import 'package:tcs_app/Screens/Student/StudentSchoolEventScreen/student_school_event_screen.dart';
import 'package:tcs_app/Screens/Teacher/AddAssignmentScreen/add_assignment_screen.dart';
import 'package:tcs_app/Screens/Teacher/AddCircularScreen/add_circular_screen.dart';
import 'package:tcs_app/Screens/Teacher/AddDiaryScreen/add_diary_screen.dart';
import 'package:tcs_app/Screens/Teacher/MarkUnidentifiedScreen/mark_unidentified_screen.dart';
import 'package:tcs_app/Screens/Teacher/TeacherAssignmentScreen/teacher_assignment_screen.dart';
import 'package:tcs_app/Screens/Teacher/TeacherClassTestResultScreen/teacher_add_class_result_screen.dart';
import 'package:tcs_app/Screens/Teacher/TeacherClassTestResultScreen/teacher_class_test_result_screen.dart';
import 'package:tcs_app/Screens/Teacher/TeacherDiaryScreen/teacher_diary_screen.dart';
import 'package:tcs_app/Screens/Teacher/TeacherSchoolEventScreen/teacher_school_event_screen.dart';
import '../Screens/ForgotPassword/ForgotPasswordScreen/forgot_password_screen.dart';
import '../Screens/ForgotPassword/ForgotPinCodeScreen/forgot_pincode_screen.dart';
import '../Screens/ForgotPassword/UpdatePasswordScreen/update_password_screen.dart';
import '../Screens/Introduction/introduction_screen.dart';
import '../Screens/NavigationalDrawer/AboutUsScreen/about_us_screen.dart';
import '../Screens/NavigationalDrawer/AppFeedbackScreen/app_feedback_screen.dart';
import '../Screens/NavigationalDrawer/ChangePasswordScreen/change_password_screen.dart';
import '../Screens/Parent/AppointmentScreen/book_an_appointment_screen.dart';
import '../Screens/Parent/ComplaintQueryScreen/complaint_query_screen.dart';
import '../Screens/Parent/ParentDashboardScreen/parent_dashboard_screen.dart';
import '../Screens/Parent/ParentEyeOnYourChildScreen/parent_eye_on_your_child_screen.dart';
import '../Screens/Registration/CreatePasswordScreen/create_password_screen.dart';
import '../Screens/Registration/RegPinCodeScreen/reg_pincode_screen.dart';
import '../Screens/Registration/RegistrationScreen/registration_screen.dart';
import '../Screens/Student/Feechallans/fee_challans_screen.dart';
import '../Screens/Student/IndividualEducationPlan/individual_education_plan_screen.dart';
import '../Screens/Student/LibraryScreen/library_screen.dart';
import '../Screens/Student/Notifications/notifications_screen.dart';
import '../Screens/Student/OSRegistrationScreen/os_registration_screen.dart';
import '../Screens/Student/ResultScreen/academic_term_screen.dart';
import '../Screens/Student/ResultScreen/results_screen.dart';
import '../Screens/Student/StudentAttendanceScreen/student_attendance_screen.dart';
import '../Screens/Student/StudentDashboardScreen/student_dashboard_screen.dart';
import '../Screens/Student/StudentProfileScreen/student_profile_screen.dart';
import '../Screens/Student/StudentSurveyScreen/student_survey_screen.dart';
import '../Screens/Teacher/AddSchoolEventScreen/add_school_event_screen.dart';
import '../Screens/Teacher/AttendanceListScreen/attendance_list_screen.dart';
import '../Screens/Teacher/EyeOnYourChildScreen/eye_on_your_child_screen.dart';
import '../Screens/Teacher/ParentAppointmentScreen/parent_appointment_screen.dart';
import '../Screens/Teacher/TeacherDashboardScreen/teacher_dashboard_screen.dart';
import '../Screens/Teacher/TeacherProfileScreen/teacher_profile_screen.dart';
import '../Screens/Teacher/TeacherSectionScreen/teacher_section_screen.dart';
import '../Screens/Teacher/TeacherSurveyScreen/teacher_survey_screen.dart';
import '../Screens/Teacher/TeacherTimeTableScreen/teacher_timetable_screen.dart';
import '../Screens/Teacher/TeacherTimeTableSectionScreen/teacher_timetable_section_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppNavRoutes.initialRoute:
        return routeScreen(child: const SplashScreenUI());
      case AppNavRoutes.promotionRoute:
        return routeScreen(
          child: PromotionScreenUI(args: settings.arguments as PromotionArgs),
        );
      case AppNavRoutes.loginRoute:
        return routeScreen(child: const LoginScreen());
      case AppNavRoutes.authWrapperRoute:
        return routeScreen(child: const AuthWrapper());
      case AppNavRoutes.registrationRoute:
        return routeScreen(child: const RegistrationScreen());
      case AppNavRoutes.forgotPinCodeRoute:
        return routeScreen(child: const ForgotPinCodeScreen());
      case AppNavRoutes.registrationPinCodeRoute:
        return routeScreen(child: const RegPinCodeScreen());
      case AppNavRoutes.createPasswordRoute:
        return routeScreen(child: const CreatePasswordScreen());
      case AppNavRoutes.studentDashboardRoute:
        return routeScreen(
          child: StudentDashboardScreen(
            args: settings.arguments as ScreenArguments,
          ),
        );
      case AppNavRoutes.parentDashboardRoute:
        return routeScreen(child: const ParentDashboardScreen());
      case AppNavRoutes.studentProfileRoute:
        return routeScreen(child: const StudentProfileScreen());
      case AppNavRoutes.academicTermRoute:
        return routeScreen(child: const AcademicTermScreen());
      case AppNavRoutes.resultsRoute:
        return routeScreen(child: const ResultsScreen());
      case AppNavRoutes.libraryRoute:
        return routeScreen(child: const LibraryScreen());
      case AppNavRoutes.notificationsRoute:
        return routeScreen(child: const NotificationScreen());
      case AppNavRoutes.feeChallansRoute:
        return routeScreen(child: const FeeChallanScreen());
      case AppNavRoutes.teacherDashboardRoute:
        return routeScreen(child: const TeacherDashboardScreen());
      case AppNavRoutes.teacherProfileRoute:
        return routeScreen(child: const TeacherProfileScreen());
      case AppNavRoutes.markAttendanceRoute:
        return routeScreen(child: const AttendanceListScreen());
      case AppNavRoutes.onlineStdRegRoute:
        return routeScreen(child: const OSRegistrationScreen());
      case AppNavRoutes.forgotPasswordRoute:
        return routeScreen(child: const ForgotPasswordScreen());
      case AppNavRoutes.updatePasswordRoute:
        return routeScreen(child: const UpdatePasswordScreen());
      case AppNavRoutes.aboutUsRoute:
        return routeScreen(child: const AboutUsScreen());
      case AppNavRoutes.appFeedbackRoute:
        return routeScreen(child: const AppFeedbackScreen());
      case AppNavRoutes.changePasswordRoute:
        return routeScreen(child: const ChangePasswordScreen());
      case AppNavRoutes.teacherSectionRoute:
        return routeScreen(child: const TeacherSectionScreen());
      case AppNavRoutes.attendanceRoute:
        return routeScreen(child: const StudentAttendanceScreen());
      case AppNavRoutes.alevelAttendanceRoute:
        return routeScreen(child: const StudentAlevelAttendanceScreen());
      case AppNavRoutes.attendanceSubjectRoute:
        return routeScreen(child: const StudentALevelAttendanceSubjectScreen());
      case AppNavRoutes.markUnidentifiedRoute:
        return routeScreen(child: const MarkUnidentifiedScreen());
      case AppNavRoutes.addDiaryRoute:
        return routeScreen(child: const AddDiaryScreen());
      case AppNavRoutes.teacherDiaryRoute:
        return routeScreen(child: const TeacherDiaryScreen());
      case AppNavRoutes.studentDiaryRoute:
        return routeScreen(child: const StudentDiaryScreen());
      case AppNavRoutes.challanPaymentRoute:
        return routeScreen(
          child: ChallanPaymentScreen(
            arguments: settings.arguments as ChallanArgs,
          ),
        );
      case AppNavRoutes.introductionRoute:
        return routeScreen(child: const IntroductionScreenPage());
      case AppNavRoutes.studentAssignmentRoute:
        return routeScreen(child: const StudentAssignmentScreen());
      case AppNavRoutes.studentSchoolEventsRoute:
        return routeScreen(child: const StudentSchoolEventScreen());
      case AppNavRoutes.addSchoolEventRoute:
        return routeScreen(child: const AddSchoolEventScreen());
      case AppNavRoutes.teacherSchoolEventsRoute:
        return routeScreen(child: const TeacherSchoolEventScreen());
      case AppNavRoutes.teacherClassTestResultRoute:
        return routeScreen(child: const TeacherClassTestResultScreen());
      case AppNavRoutes.teacherAddClassResultRoute:
        return routeScreen(child: const TeacherAddClassResultScreen());
      case AppNavRoutes.addAssignmentRoute:
        return routeScreen(child: const AddAssignmentScreen());
      case AppNavRoutes.teacherAssignmentRoute:
        return routeScreen(child: const TeacherAssignmentScreen());
      case AppNavRoutes.studentClassTestResultRoute:
        return routeScreen(child: const StudentClassResultScreen());
      case AppNavRoutes.bookanAppointmentRoute:
        return routeScreen(child: const BookanAppointmentScreen());
      case AppNavRoutes.parentAppointmentRoute:
        return routeScreen(child: const ParentAppointmentScreen());
      case AppNavRoutes.eyeOnYourChildRoute:
        return routeScreen(child: const EyeOnYourChildScreen());
      case AppNavRoutes.parentEyeOnYourChildRoute:
        return routeScreen(child: const ParentEyeOnYourChildScreen());
      case AppNavRoutes.individualEducationPlanRoute:
        return routeScreen(child: const IndividualEducationPlanScreen());
      case AppNavRoutes.teacherTimeTableSectionRoute:
        return routeScreen(child: const TeacherTimeTableSectionScreen());
      case AppNavRoutes.teacherTimeTableRoute:
        return routeScreen(child: const TeacherTimeTableScreen());
      case AppNavRoutes.teacherSurveyRoute:
        return routeScreen(child: const TeacherSurveyScreen());
      case AppNavRoutes.studentSurveyRoute:
        return routeScreen(child: const StudentSurveyScreen());
      case AppNavRoutes.withdrawalRequestRoute:
        return routeScreen(child: const WithdrawalRequestScreen());
      case AppNavRoutes.complaintQueryRoute:
        return routeScreen(child: const ComplaintQueryScreen());
      case AppNavRoutes.addCircularRoute:
        return routeScreen(child: const AddCircularScreen());

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const Scaffold(
        appBar: CustomAppBar(title: 'ERROR'),
        body: ShowError(),
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  static Route<dynamic> routeScreen({Widget? child}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          child ?? Container(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}

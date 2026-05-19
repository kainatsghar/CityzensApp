import 'package:flutter/material.dart';
import 'package:tcs_app/custom_widgets/CustomAppBar/custom_app_bar.dart';
import 'package:tcs_app/custom_widgets/ShowError/show_error.dart';
import 'package:tcs_app/routes/app_navigation_routes.dart';
import 'package:tcs_app/routes/challan_args.dart';
import 'package:tcs_app/routes/screen_arguments.dart';
import 'package:tcs_app/screens/AuthWrapper/auth_wrapper.dart';
import 'package:tcs_app/screens/LoginScreen/login_screen.dart';
import 'package:tcs_app/screens/Parent/ChallanPaymentScreen/challan_payment_screen.dart';
import 'package:tcs_app/screens/Parent/WithdrawalRequestScreen/withdrawal_request_screen.dart';
import 'package:tcs_app/screens/Promotion/promotion_screen_ui.dart';
import 'package:tcs_app/screens/SplashScreen/splash_screen_ui.dart';
import 'package:tcs_app/screens/Student/StudentAssignmentScreen/student_assignment_screen.dart';
import 'package:tcs_app/screens/Student/StudentAttendanceScreen/student_alevel_attendance_screen.dart';
import 'package:tcs_app/screens/Student/StudentClassTestResultScreen/student_class_result_screen.dart';
import 'package:tcs_app/screens/Student/StudentDiaryScreen/student_diary_screen.dart';
import 'package:tcs_app/screens/Student/StudentSchoolEventScreen/student_school_event_screen.dart';
import 'package:tcs_app/screens/Teacher/AddAssignmentScreen/add_assignment_screen.dart';
import 'package:tcs_app/screens/Teacher/AddCircularScreen/add_circular_screen.dart';
import 'package:tcs_app/screens/Teacher/AddDiaryScreen/add_diary_screen.dart';
import 'package:tcs_app/screens/Teacher/MarkUnidentifiedScreen/mark_unidentified_screen.dart';
import 'package:tcs_app/screens/Teacher/TeacherAssignmentScreen/teacher_assignment_screen.dart';
import 'package:tcs_app/screens/Teacher/TeacherClassTestResultScreen/teacher_class_result_modern_screen.dart';
import 'package:tcs_app/screens/Teacher/TeacherClassTestResultScreen/teacher_class_test_result_screen.dart';
import 'package:tcs_app/screens/Teacher/TeacherDiaryScreen/teacher_diary_screen.dart';
import 'package:tcs_app/screens/Teacher/TeacherSchoolEventScreen/teacher_school_event_screen.dart';
import '../screens/ForgotPassword/ForgotPasswordScreen/forgot_password_screen.dart';
import '../screens/ForgotPassword/ForgotPinCodeScreen/forgot_pincode_screen.dart';
import '../screens/ForgotPassword/UpdatePasswordScreen/update_password_screen.dart';
import '../screens/Introduction/introduction_screen.dart';
import '../screens/NavigationalDrawer/AboutUsScreen/about_us_screen.dart';
import '../screens/NavigationalDrawer/AppFeedbackScreen/app_feedback_screen.dart';
import '../screens/NavigationalDrawer/ChangePasswordScreen/change_password_screen.dart';
import '../screens/Parent/AppointmentScreen/book_an_appointment_screen.dart';
import '../screens/Parent/ComplaintQueryScreen/complaint_query_screen.dart';
import '../screens/Parent/ParentEyeOnYourChildScreen/parent_eye_on_your_child_screen.dart';
import '../screens/Registration/CreatePasswordScreen/create_password_screen.dart';
import '../screens/Registration/RegPinCodeScreen/reg_pincode_screen.dart';
import '../screens/Registration/RegistrationScreen/registration_screen.dart';
import '../screens/Student/Feechallans/fee_challans_screen.dart';
import '../screens/Student/IndividualEducationPlan/individual_education_plan_screen.dart';
import '../screens/Student/LibraryScreen/library_screen.dart';
import '../screens/Student/Notifications/notifications_screen.dart';
import '../screens/Student/OSRegistrationScreen/os_registration_screen.dart';
import '../screens/Student/ResultScreen/academic_term_screen.dart';
import '../screens/Student/ResultScreen/results_screen.dart';
import '../screens/Student/StudentAttendanceScreen/student_attendance_screen.dart';
import '../screens/Student/StudentDashboardScreen/student_dashboard_screen.dart';
import '../screens/Student/StudentProfileScreen/student_profile_screen.dart';
import '../screens/Student/StudentSurveyScreen/student_survey_screen.dart';
import '../screens/Teacher/AddSchoolEventScreen/add_school_event_screen.dart';
import '../screens/Teacher/AttendanceListScreen/attendance_list_screen.dart';
import '../screens/Teacher/EyeOnYourChildScreen/eye_on_your_child_screen.dart';
import '../screens/Teacher/ParentAppointmentScreen/parent_appointment_screen.dart';
import '../screens/Teacher/TeacherDashboardScreen/teacher_dashboard_screen.dart';
import '../screens/Teacher/TeacherProfileScreen/teacher_profile_screen.dart';
import '../screens/Teacher/TeacherSectionScreen/teacher_section_screen.dart';
import '../screens/Teacher/TeacherSurveyScreen/teacher_survey_screen.dart';
import '../screens/Teacher/TeacherTimeTableScreen/teacher_timetable_screen.dart';
import '../screens/Teacher/TeacherTimeTableSectionScreen/teacher_timetable_section_screen.dart';
import '../screens/Teacher/TeacherCircularScreen/teacher_circular_screen.dart';
import '../screens/Teacher/TeacherAcademicHubScreen/teacher_academic_hub_screen.dart';
import '../model/Diary/diary_response.dart';
import '../model/Assignment/assignment_response.dart';
import '../model/CircularAnnouncement/circular_announcement_response.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppNavRoutes.initialRoute:
        return routeScreen(child: const SplashScreenUI());
      case AppNavRoutes.promotionRoute:
        return routeScreen(child: const PromotionScreenUI());
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
            args: settings.arguments is ScreenArguments
                ? settings.arguments as ScreenArguments
                : null,
          ),
        );
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
      case AppNavRoutes.markUnidentifiedRoute:
        return routeScreen(child: const MarkUnidentifiedScreen());
      case AppNavRoutes.addDiaryRoute:
        return routeScreen(
          child: AddDiaryScreen(
            editRecord: settings.arguments is DiaryRecords
                ? settings.arguments as DiaryRecords
                : null,
          ),
        );
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
        return routeScreen(child: const ClassTestResultsScreen());
      case AppNavRoutes.addAssignmentRoute:
        return routeScreen(
          child: AddAssignmentScreen(
            editRecord: settings.arguments is AssignmentRecords
                ? settings.arguments as AssignmentRecords
                : null,
          ),
        );
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
        return routeScreen(
          child: AddCircularScreen(
            editRecord: settings.arguments is CircularAnnouncementRecords
                ? settings.arguments as CircularAnnouncementRecords
                : null,
          ),
        );
      case AppNavRoutes.teacherCircularRoute:
        return routeScreen(child: const TeacherCircularScreen());
      case AppNavRoutes.teacherAcademicHubRoute:
        return routeScreen(
          child: TeacherAcademicHubScreen(
            initialTabIndex: settings.arguments is int
                ? settings.arguments as int
                : 0,
          ),
        );

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

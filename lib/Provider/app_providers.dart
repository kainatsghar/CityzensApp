import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:tcs_app/Provider/Appointment/appointment_provider.dart';
import 'package:tcs_app/Provider/Assignment/assignment_provider.dart';
import 'package:tcs_app/Provider/ClassTestResult/class_test_result_provider.dart';
import 'package:tcs_app/Provider/FeeChallan/feechallan_provider.dart';
import 'package:tcs_app/Provider/ForgotPassword/forgot_password_provider.dart';
import 'package:tcs_app/Provider/Library/library_provider.dart';
import 'package:tcs_app/Provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/Provider/Login/login_provider.dart';
import 'package:tcs_app/Provider/MarkAttendance/mark_attendance_provider.dart';
import 'package:tcs_app/Provider/Notifications/notification_provider.dart';
import 'package:tcs_app/Provider/OSRegistration/os_registration_provider.dart';
import 'package:tcs_app/Provider/Registration/registration_provider.dart';
import 'package:tcs_app/Provider/Results/results_provider.dart';
import 'package:tcs_app/Provider/SchoolEvents/school_event_provider.dart';
import 'package:tcs_app/Provider/StudentProfile/student_profile_provider.dart';
import 'package:tcs_app/Provider/TeacherProfile/teacher_profile_provider.dart';

import 'Circular/circular_provider.dart';
import 'ComplaintQuery/complaint_query_provider.dart';
import 'Dashboard/dashboard_provider.dart';
import 'Diary/diary_provider.dart';
import 'EyeOnYourChild/eye_on_your_child_provider.dart';
import 'MarkUnverified/mark_unverified_provider.dart';
import 'ParentDashboard/parent_dashboard_provider.dart';
import 'StudentAttendance/student_alevel_attendance_provider.dart';
import 'StudentAttendance/student_attendance_provider.dart';
import 'Survey/survey_provider.dart';
import 'TimeTable/timetable_provider.dart';
import 'WithdrawalRequest/withdrawal_request_provider.dart';

List<SingleChildWidget> appProviders = [
  ChangeNotifierProvider(create: (_) => LoginProvider()),
  ChangeNotifierProvider(create: (_) => LocalDataProvider()),
  ChangeNotifierProvider(create: (_) => ForgotPasswordProvider()),
  ChangeNotifierProvider(create: (_) => RegistrationProvider()),
  ChangeNotifierProvider(create: (_) => StudentProfileProvider()),
  ChangeNotifierProvider(create: (_) => DashboardProvider()),
  ChangeNotifierProvider(create: (_) => LibraryProvider()),
  ChangeNotifierProvider(create: (_) => FeeChallanProvider()),
  ChangeNotifierProvider(create: (_) => ParentDashboardProvider()),
  ChangeNotifierProvider(create: (_) => NotificationProvider()),
  ChangeNotifierProvider(create: (_) => TeacherProfileProvider()),
  ChangeNotifierProvider(create: (_) => MarkAttendanceProvider()),
  ChangeNotifierProvider(create: (_) => ResultsProvider()),
  ChangeNotifierProvider(create: (_) => OSRegistrationProvider()),
  ChangeNotifierProvider(create: (_) => StudentAttendanceProvider()),
  ChangeNotifierProvider(create: (_) => StudentALevelAttendanceProvider()),
  ChangeNotifierProvider(create: (_) => MarkUnverifiedProvider()),
  ChangeNotifierProvider(create: (_) => DiaryProvider()),
  ChangeNotifierProvider(create: (_) => AssignmentProvider()),
  ChangeNotifierProvider(create: (_) => SchoolEventProvider()),
  ChangeNotifierProvider(create: (_) => ClassTestResultProvider()),
  ChangeNotifierProvider(create: (_) => AppointmentProvider()),
  ChangeNotifierProvider(create: (_) => EyeOnYourChildProvider()),
  ChangeNotifierProvider(create: (_) => TimeTableProvider()),
  ChangeNotifierProvider(create: (_) => SurveyProvider()),
  ChangeNotifierProvider(create: (_) => WithdrawalRequestProvider()),
  ChangeNotifierProvider(create: (_) => ComplaintQueryProvider()),
  ChangeNotifierProvider(create: (_) => CircularProvider()),
];

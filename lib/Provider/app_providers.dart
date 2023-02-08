import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
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
import 'package:tcs_app/Provider/StudentProfile/student_profile_provider.dart';
import 'package:tcs_app/Provider/TeacherProfile/teacher_profile_provider.dart';

import 'Dashboard/dashboard_provider.dart';
import 'ParentDashboard/parent_dashboard_provider.dart';
import 'StudentAttendance/student_attendance_provider.dart';

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
];

import 'package:tcs_app/model/Assignment/assignment_response.dart';
import 'package:tcs_app/model/Diary/diary_response.dart';
import 'package:tcs_app/model/FeeChallan/outstanding_challan_response.dart';
import 'package:tcs_app/model/Notifications/notification_response.dart';
import 'package:tcs_app/model/StudentAttendance/attendance_percentage_response.dart';
import 'package:tcs_app/model/StudentAttendance/student_attendance_response.dart';
import 'package:tcs_app/model/StudentProfile/student_profile_response.dart';
import 'package:tcs_app/model/StudentSubjects/student_subject_response.dart';

/// Aggregated dashboard payload for a single student/child.
///
/// Lives in `model/` so repositories and providers share one library URI
/// (avoids case-path duplicate-type errors on macOS).
class ChildDashboardData {
  StudentProfileResponse? profile;
  AttendancePercentageResponse? attendancePercentage;
  StudentAttendanceResponse? currentMonthAttendance;
  OutstandingChallanResponse? outstandingChallans;
  DiaryResponse? latestHomework;
  NotificationResponse? latestCirculars;
  AssignmentResponse? latestAssignments;
  StudentSubjectResponse? subjects;
}

import 'package:tcs_app/model/StudentAttendance/student_alevel_attendance_request.dart';
import 'package:tcs_app/model/StudentAttendance/student_attendance_response.dart';
// import '../../model/StudentAttendance/student_attendance_request.dart';
import '../../network/api_base_helper.dart';

class StudentALevelAttendanceService {
  static Future<StudentAttendanceResponse> studentALevelAttendanceRequest({
    required String userName,
    required int subjectId,
    required String attendanceDate,
    required String tokenId,
  }) async {
    StudentALevelAttendanceRequest request = StudentALevelAttendanceRequest(
      tokenId: tokenId,
      studentId: userName,
      subjectId: subjectId,
      pMonth: attendanceDate,
    );
    var response = await ApiBaseHelper.httpPostRequest(
      "GetMonthlyAttendance",
      body: request.toJson(),
    );
    return StudentAttendanceResponse.fromJson(response);
  }
}

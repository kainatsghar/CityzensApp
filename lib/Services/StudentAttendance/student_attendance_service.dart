import 'package:tcs_app/model/StudentAttendance/student_attendance_response.dart';
import '../../model/StudentAttendance/student_attendance_request.dart';
import '../../network/api_base_helper.dart';

class StudentAttendanceService {
  static Future<StudentAttendanceResponse> studentAttendanceRequest({
    required String userName,
    required String attendanceDate,
    required String tokenId,
  }) async {
    StudentAttendanceRequest request = StudentAttendanceRequest(
      tokenId: tokenId,
      studentId: userName,
      pMonth: attendanceDate,
    );
    var response = await ApiBaseHelper.httpPostRequest(
      "GetMonthlyAttendance",
      body: request.toJson(),
    );
    return StudentAttendanceResponse.fromJson(response);
  }
}

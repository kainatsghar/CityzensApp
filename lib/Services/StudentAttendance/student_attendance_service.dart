import 'package:tcs_app/Model/StudentAttendance/student_attendance_response.dart';
import '../../Model/StudentAttendance/student_attendance_request.dart';
import '../../Network/api_base_helper.dart';

class StudentAttendanceService {
  static Future<StudentAttendanceResponse> studentAttendanceRequest(
      {String userName, String attendanceDate, String tokenId}) async {
    StudentAttendanceRequest _request = StudentAttendanceRequest(
        tokenId: tokenId, studentId: userName, pMonth: attendanceDate);
    var response = await ApiBaseHelper.httpPostRequest("GetMonthlyAttendance",
        body: _request.toJson());
    return StudentAttendanceResponse.fromJson(response);
  }
}

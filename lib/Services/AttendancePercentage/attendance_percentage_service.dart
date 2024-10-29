import '../../Model/StudentAttendance/attendance_percentage_response.dart';
import '../../Model/StudentAttendance/student_attendance_request.dart';
import '../../Network/api_base_helper.dart';

class AttendancePercentageService {
  static Future<AttendancePercentageResponse> attendancePercentage({required String userName, required String tokenId}) async {
    StudentAttendanceRequest request = StudentAttendanceRequest(tokenId: tokenId, studentId: userName, pMonth: '');
    var response = await ApiBaseHelper.httpPostRequest("GetAttendencePercentage", body: request.toJson());
    return AttendancePercentageResponse.fromJson(response);
  }
}

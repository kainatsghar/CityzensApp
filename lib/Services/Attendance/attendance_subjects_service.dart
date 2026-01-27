import 'package:tcs_app/Model/StudentAttendance/student_alevel_attendance_subjects_response.dart';
import 'package:tcs_app/network/api_base_helper.dart';
import 'package:tcs_app/model/UserData/user_data_request.dart';
// import 'package:tcs_app/model/AcademicTerm/academic_term_response.dart';

class AttendanceSubjectsService {
  static Future<AttendanceSubjectsResponse> attendanceSubjectsRequest({
    required String userName,
  }) async {
    UserDataRequest request = UserDataRequest(userName: userName);
    var response = await ApiBaseHelper.httpPostRequest(
      "GetSubjectsByStudentId",
      body: request.toJson(),
    );
    return AttendanceSubjectsResponse.fromJson(response);
  }
}

import 'package:tcs_app/Network/api_base_helper.dart';
import 'package:tcs_app/model/StudentAttendance/student_list_request.dart';
import 'package:tcs_app/model/StudentAttendance/student_list_response.dart';

class StudentListService {
  static Future<StudentListResponse> stdListRequest(
      {String classSectionId, String attendanceDate, String tokenId}) async {
    StudentListRequest _request = StudentListRequest(
        classSectionId: classSectionId,
        attendanceData: attendanceDate,
        tokenId: tokenId);
    var response = await ApiBaseHelper.httpPostRequest("AttendanceList",
        body: _request.toJson());
    return StudentListResponse.fromJson(response);
  }
}

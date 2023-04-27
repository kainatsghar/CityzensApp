import 'package:tcs_app/Network/api_base_helper.dart';
import 'package:tcs_app/model/StudentAttendance/student_list_request.dart';
import 'package:tcs_app/model/StudentAttendance/student_list_response.dart';

class StudentListService {
  static Future<StudentListResponse> stdListRequest(
      {String classSectionId, String attendanceDate, String tokenId,int subjectId}) async {
    StudentListRequest _request = StudentListRequest(
        classSectionId: classSectionId,
        attendanceData: attendanceDate,
        subjectId: '$subjectId',
        tokenId: tokenId);
    var response = await ApiBaseHelper.httpPostRequest("AttendanceList",
        body: _request.toJson());
    print(response);
    return StudentListResponse.fromJson(response);
  }
}

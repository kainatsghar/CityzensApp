import 'package:flutter/foundation.dart';
import 'package:tcs_app/Network/api_base_helper.dart';
import 'package:tcs_app/model/StudentAttendance/student_list_request.dart';
import 'package:tcs_app/model/StudentAttendance/student_list_response.dart';

class StudentListService {
  static Future<StudentListResponse> stdListRequest(
      {required String classSectionId,
      required String attendanceDate,
      required String tokenId,
      required int subjectId}) async {
    StudentListRequest request = StudentListRequest(
        classSectionId: classSectionId,
        attendanceData: attendanceDate,
        subjectId: '$subjectId',
        tokenId: tokenId);
    var response = await ApiBaseHelper.httpPostRequest("AttendanceList",
        body: request.toJson());
    if (kDebugMode) {
      //print(response);
    }
    return StudentListResponse.fromJson(response);
  }
}

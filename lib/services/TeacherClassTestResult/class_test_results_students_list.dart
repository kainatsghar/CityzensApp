import 'package:flutter/foundation.dart';
import 'package:tcs_app/network/api_base_helper.dart';

import '../../model/ClassTestResult/class_test_student_list_request.dart';
import '../../model/ClassTestResult/class_test_student_list_response.dart';

class ClassTestStudentListService {
  static Future<ClassTestResultStudentListResponse>
  classTestResulStdListRequest({
    required String id,
    required String subjectId,
  }) async {
    ClassTestResultStudentListRequest request =
        ClassTestResultStudentListRequest(teacherId: id, subjectId: subjectId);
    var response = await ApiBaseHelper.httpPostRequest(
      "GetStudentBySubjectId",
      body: request.toJson(),
    );
    if (kDebugMode) {
      //print(response);
    }
    return ClassTestResultStudentListResponse.fromJson(response);
  }
}

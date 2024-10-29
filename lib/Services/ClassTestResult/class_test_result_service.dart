import 'package:flutter/foundation.dart';
import 'package:tcs_app/Model/AddClassTestResult/add_class_test_result_request.dart';

import '../../Model/ClassTestResult/class_test_student_list_request.dart';
import '../../Model/ClassTestResult/class_test_student_list_response.dart';
import '../../Model/ClassTestResult/student_test_result_list_request.dart';
import '../../Model/ClassTestResult/student_test_result_list_response.dart';
import '../../Network/api_base_helper.dart';
import '../../model/ResponseMessage/response_message.dart';

class ClassTestResultService {
  static Future<ClassTestResultStudentListResponse>
      classTestResulStdListRequest(
          {required String id,
          required String subjectId,
          required String sectionId,
          required int categoryId,
          required int totalMarks}) async {
    ClassTestResultStudentListRequest request =
        ClassTestResultStudentListRequest(
            teacherId: id,
            subjectId: subjectId,
            sectionId: sectionId,
            categoryId: categoryId,
            totalMarks: totalMarks);
    var response = await ApiBaseHelper.httpPostRequest("GetStudentBySubjectId",
        body: request.toJson());
    if (kDebugMode) {
      //print(response);
    }
    return ClassTestResultStudentListResponse.fromJson(response);
  }

  static Future<ResponseMessage> addStudentMarks(
      AddClassTestResultRequest addClassTestResultRequest) async {
    var response = await ApiBaseHelper.httpPostRequest("InsertUpdateTestResult",
        body: addClassTestResultRequest.toJson());
    return ResponseMessage.fromJson(response);
  }

  static Future<StudentTestResultListResponse> studentsTestResulListRequest(
      {required int status, required int id}) async {
    StudentTestResultListRequest request =
        StudentTestResultListRequest(status: status, id: id);
    var response = await ApiBaseHelper.httpPostRequest("GetTestResult",
        body: request.toJson());
    if (kDebugMode) {
      //print(response);
    }
    return StudentTestResultListResponse.fromJson(response);
  }

  // static Future<StudentTestResultWithMarksListResponse>
  //     studentsTestResulListForTeacherRequest(
  //         {required int status, required int id}) async {
  //   StudentTestResultListRequest request =
  //       StudentTestResultListRequest(status: status, id: id);
  //   var response = await ApiBaseHelper.httpPostRequest("GetTestResult",
  //       body: request.toJson());
  //   if (kDebugMode) {
  //     print(response);
  //   }
  //   return StudentTestResultWithMarksListResponse.fromJson(response);
  // }
}

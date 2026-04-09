import 'package:tcs_app/model/Assignment/assignment_request.dart';
import 'package:tcs_app/model/Assignment/assignment_response.dart';
import 'package:tcs_app/model/TeacherActions/delete_action_request.dart';
import 'package:tcs_app/model/TeacherActions/update_assignment_request.dart';
import 'package:tcs_app/model/ResponseMessage/response_message.dart';

import '../../network/api_base_helper.dart';

class TeacherAssignmentService {
  static Future<AssignmentResponse> getAssignmentRecords({
    required String userName,
    required String tokenId,
  }) async {
    AssignmentRequest request = AssignmentRequest(
      classTeacherId: userName,
      tokenId: tokenId,
    );
    var response = await ApiBaseHelper.httpPostRequest(
      "GetClassWorkTeacher",
      body: request.toJson(),
    );
    return AssignmentResponse.fromJson(response);
  }

  static Future<ResponseMessage> updateAssignment(
    UpdateAssignmentRequest request,
  ) async {
    var response = await ApiBaseHelper.httpPostRequest(
      "UpdateClassWork",
      body: request.toJson(),
    );
    return ResponseMessage.fromJson(response);
  }

  static Future<ResponseMessage> deleteAssignment(
    DeleteActionRequest request,
  ) async {
    var response = await ApiBaseHelper.httpPostRequest(
      "DeleteClassWork",
      body: request.toJson(),
    );
    return ResponseMessage.fromJson(response);
  }
}

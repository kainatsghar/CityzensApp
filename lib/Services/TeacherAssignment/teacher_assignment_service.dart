import 'package:tcs_app/Model/Assignment/assignment_request.dart';
import 'package:tcs_app/Model/Assignment/assignment_response.dart';

import '../../Network/api_base_helper.dart';

class TeacherAssignmentService {
  static Future<AssignmentResponse> getAssignmentRecords(
      {required String userName, required String tokenId}) async {
    AssignmentRequest request =
        AssignmentRequest(classTeacherId: userName, tokenId: tokenId);
    var response = await ApiBaseHelper.httpPostRequest("GetClassWorkTeacher",
        body: request.toJson());
    return AssignmentResponse.fromJson(response);
  }
}

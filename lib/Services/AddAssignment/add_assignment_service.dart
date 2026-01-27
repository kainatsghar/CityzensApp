import '../../Model/AddAssignment/add_assignment_request.dart';
import '../../network/api_base_helper.dart';
import '../../model/ResponseMessage/response_message.dart';

class AddAssignmentService {
  static Future<ResponseMessage> addAssignment(
    AddAssignmentRequest addAssignmentRequest,
  ) async {
    var response = await ApiBaseHelper.httpPostRequest(
      "AddClassAssignment",
      body: addAssignmentRequest.toJson(),
    );
    return ResponseMessage.fromJson(response);
  }
}

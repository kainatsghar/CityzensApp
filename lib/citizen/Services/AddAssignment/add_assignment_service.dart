import 'package:tcs_app/citizen/Model/AddAssignment/add_assignment_request.dart';
import 'package:tcs_app/citizen/Network/api_base_helper.dart';
import 'package:tcs_app/citizen/Model/ResponseMessage/response_message.dart';

class AddAssignmentService {
  static Future<ResponseMessage> addAssignment(
      AddAssignmentRequest addAssignmentRequest) async {
    var response = await ApiBaseHelper.httpPostRequest(
      "AddClassAssignment",
      body: addAssignmentRequest.toJson(),
    );
    return ResponseMessage.fromJson(response);
  }
}

import 'package:tcs_app/citizen/Model/MarkUnverified/mark_unverified_request.dart';
import 'package:tcs_app/citizen/Model/ResponseMessage/response_message.dart';
import 'package:tcs_app/Network/api_base_helper.dart';

class MarkUnverifiedService {
  static Future<ResponseMessage> markUnverified(
      MarkUnverifiedRequest unverifiedRequest) async {
    var response = await ApiBaseHelper.httpPostRequest(
        "StudentVerificationInsert",
        body: unverifiedRequest.toJson());
    return ResponseMessage.fromJson(response);
  }
}

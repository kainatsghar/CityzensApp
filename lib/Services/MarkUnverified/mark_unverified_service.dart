import '../../Model/MarkUnverified/mark_unverified_request.dart';
import '../../Model/ResponseMessage/response_message.dart';
import '../../Network/api_base_helper.dart';

class MarkUnverifiedService {
  static Future<ResponseMessage> markUnverified(
      MarkUnverifiedRequest unverifiedRequest) async {
    var response = await ApiBaseHelper.httpPostRequest(
        "StudentVerificationInsert",
        body: unverifiedRequest.toJson());
    return ResponseMessage.fromJson(response);
  }
}

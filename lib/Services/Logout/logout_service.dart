import 'package:tcs_app/Network/api_base_helper.dart';
import 'package:tcs_app/model/Logout/logout_request.dart';
import 'package:tcs_app/model/ResponseMessage/response_message.dart';

class LogoutService {
  static Future<ResponseMessage> logoutRequest(String tokenId) async {
    LogoutRequest request = LogoutRequest(tokenId: tokenId);
    var response = await ApiBaseHelper.httpPostRequest("Logout", body: request.toJson());
    return ResponseMessage.fromJson(response);
  }
}

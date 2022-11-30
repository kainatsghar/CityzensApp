import 'package:tcs_app/Network/api_base_helper.dart';
import 'package:tcs_app/model/ChangePassword/change_password_request.dart';
import 'package:tcs_app/model/ResponseMessage/response_message.dart';

class ChangePasswordService {
  static Future<ResponseMessage> changePasswordRequest(
      {String userName,
      String oldPassword,
      String newPassword,
      String userType}) async {
    ChangePasswordRequest _request = ChangePasswordRequest(
        username: userName,
        oldPassword: oldPassword,
        newPassword: newPassword,
        userType: userType);
    var response = await ApiBaseHelper.httpPostRequest("ChangePassword",
        body: _request.toJson());
    return ResponseMessage.fromJson(response);
  }
}

import 'package:tcs_app/network/api_base_helper.dart';
import 'package:tcs_app/model/ChangePassword/change_password_request.dart';
import 'package:tcs_app/model/ResponseMessage/response_message.dart';

class ChangePasswordService {
  static Future<ResponseMessage> changePasswordRequest({
    required String userName,
    required String oldPassword,
    // String newPassword,
    required String userType,
  }) async {
    ChangePasswordRequest request = ChangePasswordRequest(
      username: userName,
      oldPassword: oldPassword,
      // newPassword: newPassword,
      userType: userType,
    );
    var response = await ApiBaseHelper.httpPostRequest(
      "ChangePassword",
      body: request.toJson(),
    );
    return ResponseMessage.fromJson(response);
  }
}

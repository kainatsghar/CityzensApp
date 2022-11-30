import 'package:platform_device_id/platform_device_id.dart';
import 'package:tcs_app/Network/api_base_helper.dart';
import 'package:tcs_app/model/Registration/registration_request.dart';
import 'package:tcs_app/model/ResponseMessage/response_message.dart';

class UpdatePasswordService {
  static Future<ResponseMessage> updatePasswordRequest(
      {String userName,
      String confirmPassword,
      String userType,
      bool isRegPass = false}) async {
    String deviceId = await PlatformDeviceId.getDeviceId;
    RegistrationRequest _request = RegistrationRequest(
        username: userName,
        password: confirmPassword,
        userType: userType,
        deviceId: deviceId);
    var response = await ApiBaseHelper.httpPostRequest(
        isRegPass ? "CreatePassword" : "UpdatePassword",
        body: _request.toJson());
    var forgotResponse = ResponseMessage.fromJson(response);
    return forgotResponse;
  }
}

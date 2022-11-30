import 'package:platform_device_id/platform_device_id.dart';
import 'package:tcs_app/Network/api_base_helper.dart';
import 'package:tcs_app/model/Registration/registration_request.dart';
import 'package:tcs_app/model/ResponseMessage/response_message.dart';

class VerifyPinCodeService {
  static Future<ResponseMessage> verifyPinCodeRequest(
      {String userName,
      String pinCode,
      String userType,
      bool isRegPin = false}) async {
    String deviceId = await PlatformDeviceId.getDeviceId;
    RegistrationRequest _request = RegistrationRequest(
        username: userName,
        pinCode: pinCode,
        userType: userType,
        deviceId: deviceId);
    var response = await ApiBaseHelper.httpPostRequest(
        isRegPin ? "PinCodeVerify" : "CheckPinCode",
        body: _request.toJson());
    return ResponseMessage.fromJson(response);
  }
}

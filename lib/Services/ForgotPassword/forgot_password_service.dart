import 'package:platform_device_id/platform_device_id.dart';
import 'package:tcs_app/Network/api_base_helper.dart';
import 'package:tcs_app/model/Registration/registration_request.dart';
import 'package:tcs_app/model/ResponseMessage/response_message.dart';

class ForgotPasswordService {
  static Future<ResponseMessage> forgotPasswordRequest(
  { String userName, String mobileNumber, String userType}) async {
    String deviceId = await PlatformDeviceId.getDeviceId;
    RegistrationRequest _request = RegistrationRequest(
        username: userName,
        mobileNumber: mobileNumber,
        userType: userType,
        deviceId: deviceId);
    var response = await ApiBaseHelper.httpPostRequest("ForgetPassword",
        body: _request.toJson());
    var forgotResponse = ResponseMessage.fromJson(response);
    return forgotResponse;
  }
}

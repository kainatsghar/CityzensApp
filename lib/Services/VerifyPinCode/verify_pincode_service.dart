import 'package:tcs_app/network/api_base_helper.dart';
import 'package:tcs_app/Utils/helper_function.dart';
import 'package:tcs_app/model/Registration/registration_request.dart';
import 'package:tcs_app/model/ResponseMessage/response_message.dart';

class VerifyPinCodeService {
  static Future<ResponseMessage> verifyPinCodeRequest({
    required String userName,
    required String pinCode,
    required String userType,
    bool isRegPin = false,
  }) async {
    String deviceId = await HelperFunction.getId();
    RegistrationRequest request = RegistrationRequest(
      username: userName,
      pinCode: pinCode,
      userType: userType,
      deviceId: deviceId,
    );
    var response = await ApiBaseHelper.httpPostRequest(
      isRegPin ? "PinCodeVerify" : "CheckPinCode",
      body: request.toJson(),
    );
    return ResponseMessage.fromJson(response);
  }
}

import 'package:tcs_app/network/api_base_helper.dart';
import 'package:tcs_app/Utils/helper_function.dart';
import 'package:tcs_app/model/Registration/registration_request.dart';
import 'package:tcs_app/model/ResponseMessage/response_message.dart';

class ForgotPasswordService {
  static Future<ResponseMessage> forgotPasswordRequest({
    required String userName,
    required String mobileNumber,
    required String userType,
  }) async {
    String deviceId = await HelperFunction.getId();
    RegistrationRequest request = RegistrationRequest(
      username: userName,
      mobileNumber: mobileNumber,
      userType: userType,
      deviceId: deviceId,
    );
    var response = await ApiBaseHelper.httpPostRequest(
      "ForgetPassword",
      body: request.toJson(),
    );
    var forgotResponse = ResponseMessage.fromJson(response);
    return forgotResponse;
  }
}

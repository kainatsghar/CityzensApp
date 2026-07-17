import 'package:tcs_app/network/api_base_helper.dart';
import 'package:tcs_app/utils/helper_function.dart';
import 'package:tcs_app/model/Registration/registration_request.dart';
import 'package:tcs_app/model/ResponseMessage/response_message.dart';

class UpdatePasswordService {
  static Future<ResponseMessage> updatePasswordRequest({
    required String userName,
    required String confirmPassword,
    required String userType,
    bool isRegPass = false,
  }) async {
    String deviceId = await HelperFunction.getId();
    RegistrationRequest request = RegistrationRequest(
      username: userName,
      password: confirmPassword,
      userType: userType,
      deviceId: deviceId,
    );
    var response = await ApiBaseHelper.httpPostRequest(
      isRegPass ? "CreatePassword" : "UpdatePassword",
      body: request.toJson(),
    );
    var forgotResponse = ResponseMessage.fromJson(response);
    return forgotResponse;
  }
}

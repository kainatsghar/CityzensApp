import 'package:tcs_app/network/api_base_helper.dart';
import 'package:tcs_app/utils/helper_function.dart';
import 'package:tcs_app/model/Registration/registration_request.dart';
import 'package:tcs_app/model/ResponseMessage/response_message.dart';

class RegistrationService {
  static Future<ResponseMessage> userRegRequest({
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
      "Registration",
      body: request.toJson(),
    );
    return ResponseMessage.fromJson(response);
  }
}

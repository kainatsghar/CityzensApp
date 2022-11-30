import 'package:tcs_app/Network/api_base_helper.dart';
import 'package:tcs_app/model/Login/login_request.dart';
import 'package:tcs_app/model/Login/login_response.dart';

class LoginService {
  static Future<LoginResponse> loginRequest(
      String username, String password, String userType) async {
    LoginRequest _loginRequest = LoginRequest(
        username: username, password: password, userType: userType);
    var response = await ApiBaseHelper.httpPostRequest("Auth",
        body: _loginRequest.toJson());
    var loginResponse = LoginResponse.fromJson(response);
    return loginResponse;
  }
}

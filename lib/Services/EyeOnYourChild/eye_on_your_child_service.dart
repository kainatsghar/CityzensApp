import '../../Model/EyeOnYourChild/eye_on_your_child_request.dart';
import '../../Model/EyeOnYourChild/eye_on_your_child_response.dart';
import '../../network/api_base_helper.dart';

class EyeOnYourChildService {
  static Future<EyeOnYourChildResponse> getEyeOnChildConfig({
    required int userName,
  }) async {
    EyeOnYourChildRequest request = EyeOnYourChildRequest(id: userName);
    var response = await ApiBaseHelper.httpPostRequest(
      "GetEyeOnYourChildData",
      body: request.toJson(),
    );
    return EyeOnYourChildResponse.fromJson(response);
  }
}

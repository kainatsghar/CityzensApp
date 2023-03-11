import '../../Model/UnverifiedReasons/unverified_reasons_response.dart';
import '../../Network/api_base_helper.dart';

class UnverifiedReasonsService {
  static Future<UnverifiedReasonsResponse> getReasons() async {
    var response = await ApiBaseHelper.httpPostRequest(
        "GetStudentVerificationReason",
        body: {});
    return UnverifiedReasonsResponse.fromJson(response);
  }
}

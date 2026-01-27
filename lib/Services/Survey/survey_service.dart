import 'package:tcs_app/network/api_base_helper.dart';
import '../../Model/Survey/survey_request.dart';
import '../../Model/Survey/survey_response.dart';

class SurveyService {
  static Future<SurveyResponse> getSurveyRecords({
    required String userId,
  }) async {
    SurveyRequest request = SurveyRequest(userId: userId);
    var response = await ApiBaseHelper.httpPostRequest(
      "GetSurveyById",
      body: request.toJson(),
    );
    return SurveyResponse.fromJson(response);
  }
}

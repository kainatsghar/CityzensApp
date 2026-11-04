import 'package:tcs_app/citizen/Network/api_base_helper.dart';
import 'package:tcs_app/citizen/Model/Survey/survey_request.dart';
import 'package:tcs_app/citizen/Model/Survey/survey_response.dart';

class SurveyService {
  static Future<SurveyResponse> getSurveyRecords(
      {required String userId}) async {
    SurveyRequest request = SurveyRequest(
      userId: userId,
    );
    var response = await ApiBaseHelper.httpPostRequest("GetSurveyById",
        body: request.toJson());
    return SurveyResponse.fromJson(response);
  }
}

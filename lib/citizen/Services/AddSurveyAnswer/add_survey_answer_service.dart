import 'package:tcs_app/citizen/Model/AddSurvey/add_survey_request.dart';
import 'package:tcs_app/citizen/Network/api_base_helper.dart';
import 'package:tcs_app/citizen/Model/ResponseMessage/response_message.dart';

class AddSurveyAnswerService {
  static Future<ResponseMessage> addSurveyAnswers(
      AddSurveyAnswersRequest addTimeTableRequest) async {
    var response = await ApiBaseHelper.httpPostRequest(
      "UpdateSurveyAnswers",
      body: addTimeTableRequest.toJson(),
    );
    return ResponseMessage.fromJson(response);
  }
}

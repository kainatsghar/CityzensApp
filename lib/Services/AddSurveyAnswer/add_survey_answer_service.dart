import '../../Model/AddSurvey/add_survey_request.dart';
import '../../Network/api_base_helper.dart';
import '../../model/ResponseMessage/response_message.dart';

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

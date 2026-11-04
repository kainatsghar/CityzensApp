import 'package:tcs_app/citizen/Model/AddTimeTable/add_timetable_request.dart';
import 'package:tcs_app/Network/api_base_helper.dart';
import 'package:tcs_app/citizen/Model/ResponseMessage/response_message.dart';

class AddTimetableService {
  static Future<ResponseMessage> addTimetable(
      AddTimeTableRequest addTimeTableRequest) async {
    var response = await ApiBaseHelper.httpPostRequest(
      "SaveUpdateClassTimeTable",
      body: addTimeTableRequest.toJson(),
    );
    return ResponseMessage.fromJson(response);
  }
}

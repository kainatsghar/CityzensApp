import '../../model/AddTimeTable/add_timetable_request.dart';
import '../../network/api_base_helper.dart';
import '../../model/ResponseMessage/response_message.dart';

class AddTimetableService {
  static Future<ResponseMessage> addTimetable(
    AddTimeTableRequest addTimeTableRequest,
  ) async {
    var response = await ApiBaseHelper.httpPostRequest(
      "SaveUpdateClassTimeTable",
      body: addTimeTableRequest.toJson(),
    );
    return ResponseMessage.fromJson(response);
  }
}

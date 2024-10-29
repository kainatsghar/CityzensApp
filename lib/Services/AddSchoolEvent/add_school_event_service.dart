import 'package:tcs_app/Model/AddSchoolEvent/add_school_event_request.dart';

import '../../Model/ResponseMessage/response_message.dart';
import '../../Network/api_base_helper.dart';

class AddSchoolEventService {
  static Future<ResponseMessage> addSchoolEvent(
      AddSchoolEventRequest addSchoolEventRequest) async {
    var response = await ApiBaseHelper.httpPostRequest(
        "InsertUpdateEventCalender",
        body: addSchoolEventRequest.toJson());
    return ResponseMessage.fromJson(response);
  }
}

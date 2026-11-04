import 'package:tcs_app/citizen/Model/ResponseMessage/response_message.dart';
import 'package:tcs_app/citizen/Network/api_base_helper.dart';

import 'package:tcs_app/citizen/Model/AddCircular/add_circular_request.dart';

class AddCircularService {
  static Future<ResponseMessage> addCircular(
      AddCircularRequest addDiaryRequest) async {
    var response = await ApiBaseHelper.httpPostRequest(
        "SaveCircularAnnouncement",
        body: addDiaryRequest.toJson());
    return ResponseMessage.fromJson(response);
  }
}

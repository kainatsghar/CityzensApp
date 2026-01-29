import 'package:tcs_app/model/ResponseMessage/response_message.dart';
import 'package:tcs_app/network/api_base_helper.dart';

import '../../model/AddCircular/add_circular_request.dart';

class AddCircularService {
  static Future<ResponseMessage> addCircular(
    AddCircularRequest addDiaryRequest,
  ) async {
    var response = await ApiBaseHelper.httpPostRequest(
      "SaveCircularAnnouncement",
      body: addDiaryRequest.toJson(),
    );
    return ResponseMessage.fromJson(response);
  }
}

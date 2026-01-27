import 'package:tcs_app/Model/AddDiary/add_diary_request.dart';
import 'package:tcs_app/Model/ResponseMessage/response_message.dart';
import 'package:tcs_app/network/api_base_helper.dart';

class AddDiaryService {
  static Future<ResponseMessage> addDiary(
    AddDiaryRequest addDiaryRequest,
  ) async {
    var response = await ApiBaseHelper.httpPostRequest(
      "AddDiary",
      body: addDiaryRequest.toJson(),
    );
    return ResponseMessage.fromJson(response);
  }
}

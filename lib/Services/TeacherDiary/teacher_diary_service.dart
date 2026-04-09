import 'package:tcs_app/model/TeacherActions/delete_action_request.dart';
import 'package:tcs_app/model/TeacherActions/update_diary_request.dart';
import 'package:tcs_app/model/ResponseMessage/response_message.dart';
import 'package:tcs_app/network/api_base_helper.dart';

import '../../model/Diary/diary_request.dart';
import '../../model/Diary/diary_response.dart';

class TeacherDiaryService {
  static Future<DiaryResponse> getDiaryRecords({
    required String userName,
    required String tokenId,
  }) async {
    DiaryRequest request = DiaryRequest(
      classTeacherId: userName,
      tokenId: tokenId,
    );
    var response = await ApiBaseHelper.httpPostRequest(
      "GetDiaryDetailsOfTeacher",
      body: request.toJson(),
    );
    return DiaryResponse.fromJson(response);
  }

  static Future<ResponseMessage> updateDiary(
    UpdateDiaryRequest request,
  ) async {
    var response = await ApiBaseHelper.httpPostRequest(
      "UpdateDiary",
      body: request.toJson(),
    );
    return ResponseMessage.fromJson(response);
  }

  static Future<ResponseMessage> deleteDiary(
    DeleteActionRequest request,
  ) async {
    var response = await ApiBaseHelper.httpPostRequest(
      "DeleteDiary",
      body: request.toJson(),
    );
    return ResponseMessage.fromJson(response);
  }
}

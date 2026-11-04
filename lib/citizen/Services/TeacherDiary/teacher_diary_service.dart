import 'package:tcs_app/citizen/Network/api_base_helper.dart';

import 'package:tcs_app/citizen/Model/Diary/diary_request.dart';
import 'package:tcs_app/citizen/Model/Diary/diary_response.dart';

class TeacherDiaryService {
  static Future<DiaryResponse> getDiaryRecords({required String userName, required String tokenId}) async {
    DiaryRequest request = DiaryRequest(classTeacherId: userName, tokenId: tokenId);
    var response = await ApiBaseHelper.httpPostRequest("GetDiaryDetailsOfTeacher", body: request.toJson());
    return DiaryResponse.fromJson(response);
  }
}

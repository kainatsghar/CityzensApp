import 'package:tcs_app/Network/api_base_helper.dart';

import '../../Model/Diary/diary_request.dart';
import '../../Model/Diary/diary_response.dart';

class TeacherDiaryService {
  static Future<DiaryResponse> getDiaryRecords(
      {String userName, String tokenId}) async {
    DiaryRequest _request =
        DiaryRequest(classTeacherId: userName, tokenId: tokenId);
    var response = await ApiBaseHelper.httpPostRequest(
        "GetDiaryDetailsOfTeacher",
        body: _request.toJson());
    return DiaryResponse.fromJson(response);
  }
}

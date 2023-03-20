import 'package:tcs_app/Network/api_base_helper.dart';
import '../../Model/Diary/diary_request.dart';
import '../../Model/Diary/diary_response.dart';

class StudentDiaryService {
  static Future<DiaryResponse> getDiaryRecords(
      {String userName, String tokenId}) async {
    DiaryRequest _request = DiaryRequest(studentId: userName, tokenId: tokenId);
    var response = await ApiBaseHelper.httpPostRequest("GetDiaryDetails",
        body: _request.toJson());
    return DiaryResponse.fromJson(response);
  }
}

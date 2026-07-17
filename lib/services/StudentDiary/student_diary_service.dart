import 'package:tcs_app/network/api_base_helper.dart';
import '../../model/Diary/diary_request.dart';
import '../../model/Diary/diary_response.dart';

class StudentDiaryService {
  static Future<DiaryResponse> getDiaryRecords({
    required String userName,
    required String tokenId,
  }) async {
    DiaryRequest request = DiaryRequest(studentId: userName, tokenId: tokenId);
    var response = await ApiBaseHelper.httpPostRequest(
      "GetDiaryDetails",
      body: request.toJson(),
    );
    return DiaryResponse.fromJson(response);
  }
}

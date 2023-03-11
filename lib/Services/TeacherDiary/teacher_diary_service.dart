import 'package:tcs_app/Model/TeacherDiary/teacher_diary_request.dart';
import 'package:tcs_app/Model/TeacherDiary/teacher_diary_response.dart';
import 'package:tcs_app/Network/api_base_helper.dart';

class TeacherDiaryService {
  static Future<TeacherDiaryResponse> getDiaryRecords({String userName}) async {
    TeacherDiaryRequest _request =
        TeacherDiaryRequest(classTeacherId: userName);
    var response = await ApiBaseHelper.httpPostRequest(
        "GetDiaryDetailsOfTeacher",
        body: _request.toJson());
    return TeacherDiaryResponse.fromJson(response);
  }
}

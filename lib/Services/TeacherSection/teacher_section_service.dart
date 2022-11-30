import 'package:tcs_app/Network/api_base_helper.dart';
import 'package:tcs_app/model/StudentProfile/student_profile_response.dart';
import 'package:tcs_app/model/TeacherSection/teacher_section_response.dart';
import 'package:tcs_app/model/UserData/user_data_request.dart';

class TeacherSectionService {
  static Future<TeacherSectionResponse> sectionRequest(
      {String userName, String token, }) async {
    UserDataRequest _request = UserDataRequest(
        userName: userName,
        tokenId: token);
    var response = await ApiBaseHelper.httpPostRequest("GetSections",
        body: _request.toJson());
    return TeacherSectionResponse.fromJson(response);
  }
}
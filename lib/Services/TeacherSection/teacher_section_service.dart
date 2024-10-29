import 'package:tcs_app/Network/api_base_helper.dart';
import 'package:tcs_app/model/TeacherSection/teacher_section_response.dart';
import 'package:tcs_app/model/UserData/user_data_request.dart';

class TeacherSectionService {
  static Future<TeacherSectionResponse> sectionRequest(
      {required String userName,
      required String token,
      bool isDiary = false}) async {
    UserDataRequest request =
        UserDataRequest(userName: userName, tokenId: token, isDiary: isDiary);
    var response = await ApiBaseHelper.httpPostRequest("GetSections",
        body: request.toJson());
    return TeacherSectionResponse.fromJson(response);
  }
}

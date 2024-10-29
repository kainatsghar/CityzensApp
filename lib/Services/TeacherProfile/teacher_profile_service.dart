import 'package:tcs_app/Network/api_base_helper.dart';
import 'package:tcs_app/model/TeacherProfile/teacher_profile_response.dart';
import 'package:tcs_app/model/UserData/user_data_request.dart';

class TeacherProfileService {
  static Future<TeacherProfileResponse> teacherProfileRequest({required String userName, required String token}) async {
    UserDataRequest request = UserDataRequest(tokenId: token, userName: userName);
    var response = await ApiBaseHelper.httpPostRequest("TeacherProfile", body: request.toJson());
    return TeacherProfileResponse.fromJson(response);
  }
}

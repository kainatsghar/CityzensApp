import 'package:tcs_app/Network/api_base_helper.dart';
import 'package:tcs_app/model/TeacherProfile/teacher_profile_response.dart';
import 'package:tcs_app/model/UserData/user_data_request.dart';

class TeacherProfileService {
  static Future<TeacherProfileResponse> teacherProfileRequest(
      {String userName,String token}) async {
    UserDataRequest _request = UserDataRequest(tokenId: token,userName: userName);
    var response = await ApiBaseHelper.httpPostRequest("TeacherProfile",
        body: _request.toJson());
    return TeacherProfileResponse.fromJson(response);
  }
}
